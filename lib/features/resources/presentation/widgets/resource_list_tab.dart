import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/resource_bloc.dart';
import '../../domain/entities/resource_entity.dart';

class ResourceListTab extends StatefulWidget {
  const ResourceListTab({super.key});

  @override
  State<ResourceListTab> createState() => _ResourceListTabState();
}

class _ResourceListTabState extends State<ResourceListTab> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: BlocBuilder<ResourceBloc, ResourceState>(
            builder: (context, state) {
              if (state is ResourceLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ResourceLoaded) {
                return _buildResourceList(state.resources);
              } else if (state is ResourceError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Start exploring FBLA resources!'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search handbooks, guidelines...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<ResourceBloc>().add(FetchResourcesEvent());
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (query) {
          context.read<ResourceBloc>().add(SearchResourcesEvent(query));
        },
      ),
    );
  }

  Widget _buildResourceList(List<ResourceEntity> resources) {
    if (resources.isEmpty) {
      return const Center(child: Text('No resources found. Try another search.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: _getResourceIcon(resource.type),
            title: Text(
              resource.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(resource.description),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    resource.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF003366),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: resource.url != null ? () => _launchURL(resource.url!) : null,
          ),
        );
      },
    );
  }

  Widget _getResourceIcon(String? type) {
    IconData iconData;
    Color color;

    switch (type?.toUpperCase()) {
      case 'PDF':
        iconData = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'VIDEO':
        iconData = Icons.play_circle_fill;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.link;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: color),
    );
  }
}
