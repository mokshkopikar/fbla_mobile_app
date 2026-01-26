import 'package:flutter/material.dart';
import '../../../member_profile/presentation/pages/member_profile_page.dart';
import '../../../news_feed/presentation/widgets/news_feed_tab.dart';
import '../../../event_calendar/presentation/widgets/event_calendar_tab.dart';
import '../../../resources/presentation/widgets/resource_list_tab.dart';
import '../../../social/presentation/widgets/social_feed_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 1; // Default to Newsfeed tab (index 1)

  static const List<Widget> _widgetOptions = <Widget>[
    EventCalendarTab(),
    NewsFeedTab(),
    ResourceListTab(),
    SocialFeedTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Welcome to FBLA Engagement'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: [
              Text('• Events: Stay updated on NLC, SLC, and state deadlines.'),
              Text('• News: Real-time updates from FBLA National.'),
              Text('• Resources: Access guidelines and competitive materials.'),
              Text('• Social: Share your engagement with your community.'),
              SizedBox(height: 12),
              Text('Tip: Use the search bar in News or Resources to find specifics quickly!'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: 'FBLA Future Engagement Dashboard',
          child: const Text('FBLA Dashboard'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showInstructions(context),
            tooltip: 'App Instructions',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemberProfilePage()),
              );
            },
            tooltip: 'My FBLA Profile',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF003366), // FBLA Blue
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
