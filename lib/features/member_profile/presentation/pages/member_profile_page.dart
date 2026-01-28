import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/member_profile_bloc.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/profile_validator.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';

/// UI Page for viewing and editing the Member Profile.
/// 
/// [Clean Architecture - Presentation Layer]: This widget only cares about
/// states and events. It doesn't know where the data comes from.
/// 
/// **Navigation**: Includes bottom navigation bar to allow users to navigate
/// to other screens (Events, News, Resources, Social) without going back first.
class MemberProfilePage extends StatelessWidget {
  const MemberProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MemberProfileBloc>()..add(GetProfileEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My FBLA Profile'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: const MemberProfileView(),
        // Bottom navigation bar for easy navigation to other screens
        // This allows users to switch between features without going back
        bottomNavigationBar: _ProfileBottomNavigationBar(),
      ),
    );
  }
}

/// Bottom navigation bar for the Member Profile page.
/// 
/// Provides persistent navigation to all main app features, allowing users
/// to switch between screens without having to go back to the dashboard first.
class _ProfileBottomNavigationBar extends StatelessWidget {
  const _ProfileBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF003366), // FBLA Blue
      unselectedItemColor: Colors.grey,
      currentIndex: 4, // Profile is the 5th item (index 4)
      onTap: (index) {
        // Navigate based on selected index
        if (index == 4) {
          // Already on profile page, do nothing
          return;
        }
        
        // Navigate back to dashboard with the selected tab
        // Pop the profile page and return the selected index
        Navigator.of(context).pop(index);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          label: 'Resources',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Social',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}

class MemberProfileView extends StatelessWidget {
  const MemberProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberProfileBloc, MemberProfileState>(
      builder: (context, state) {
        if (state is MemberProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MemberProfileLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(state.member),
                const SizedBox(height: 24),
                _buildInfoSection(context, state.member),
              ],
            ),
          );
        } else if (state is MemberProfileError) {
          return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildProfileHeader(member) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            member.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'FBLA ID: ${member.id}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, member) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Email', member.email, Icons.email),
            const Divider(),
            _buildDetailRow('Chapter', member.chapter, Icons.location_city),
            const Divider(),
            _buildDetailRow('Grade Level', member.gradeLevel, Icons.school),
            const SizedBox(height: 16),
            // Accessibility: High contrast button for actions
            ElevatedButton.icon(
              onPressed: () => _showEditDialog(context, member),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Member member) {
    final formKey = GlobalKey<FormState>();
    final firstNameController = TextEditingController(text: member.firstName);
    final lastNameController = TextEditingController(text: member.lastName);
    final emailController = TextEditingController(text: member.email);
    final chapterController = TextEditingController(text: member.chapter);
    final gradeController = TextEditingController(text: member.gradeLevel);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: ProfileValidator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: chapterController,
                  decoration: const InputDecoration(labelText: 'Chapter'),
                  validator: ProfileValidator.validateChapter,
                ),
                TextFormField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Grade Level (9-12)'),
                  validator: ProfileValidator.validateGradeLevel,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final updatedMember = Member(
                  id: member.id,
                  firstName: firstNameController.text,
                  lastName: lastNameController.text,
                  email: emailController.text,
                  chapter: chapterController.text,
                  gradeLevel: gradeController.text,
                );
                context.read<MemberProfileBloc>().add(UpdateProfileEvent(updatedMember));
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
