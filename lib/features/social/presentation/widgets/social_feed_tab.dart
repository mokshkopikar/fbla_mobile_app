import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../bloc/social_bloc.dart';
import '../../domain/entities/social_post_entity.dart';

class SocialFeedTab extends StatelessWidget {
  const SocialFeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: BlocBuilder<SocialBloc, SocialState>(
            builder: (context, state) {
              if (state is SocialLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SocialLoaded) {
                return _buildPostList(state.posts);
              } else if (state is SocialError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('Stay connected with FBLA!'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF003366).withOpacity(0.05),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF003366),
            child: const Icon(Icons.share, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FBLA Social Feed',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Updates from National & State Chapters',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              // Demonstrating Native Social Integration
              Share.share(
                'Join me in FBLA! 🚀 Check out the official Future of Member Engagement app: https://fbla.org',
                subject: 'Join FBLA Future Engagement',
              );
            },
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Invite'),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(List<SocialPostEntity> posts) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final timeAgo = _getTimeAgo(post.timestamp);
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[800],
                      child: Text(post.authorName[0], style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(post.authorHandle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                    Text(timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.content),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 24),
                    const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, size: 20, color: Colors.grey),
                      onPressed: () {
                        // Native share for specific post content
                        Share.share(
                          'Check out this FBLA update: "${post.content}" - shared via FBLA Member App',
                          subject: 'FBLA Update',
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
