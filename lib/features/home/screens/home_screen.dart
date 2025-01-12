import 'package:flutter/material.dart';
import '../../../widgets/common/custom_bottom_nav_bar.dart';
import '../../events/screens/event_list_screen.dart';
import '../../events/screens/create_event_screen.dart';
import '../../user/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Home Feed')), // Home screen
    const Center(child: Text('Search')), // Search screen
    const EventListScreen(), // Events screen
    const ProfileScreen(), // Profile screen
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Create button index
      CreateEventBottomSheet.show(context);
    } else {
      // Adjust index for the screens list since we removed the create screen
      final adjustedIndex = index > 2 ? index - 1 : index;
      setState(() {
        _selectedIndex = adjustedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex > 1
            ? _selectedIndex + 1
            : _selectedIndex, // Adjust for nav bar highlighting
        onItemSelected: _onItemTapped,
      ),
    );
  }
}
