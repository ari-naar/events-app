import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome05,
              color: Colors.grey,
              size: 24.0.sp,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedHome05,
              color: Colors.black,
              size: 24.0.sp,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.grey,
              size: 24.0.sp,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              color: Colors.black,
              size: 24.0.sp,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit01,
              color: Colors.grey,
              size: 24.0.sp,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedPencilEdit01,
              color: Colors.black,
              size: 24.0.sp,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              color: Colors.grey,
              size: 24.0.sp,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedCalendar01,
              color: Colors.black,
              size: 24.0.sp,
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: Colors.grey,
              size: 24.0.sp,
            ),
            activeIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedUserCircle,
              color: Colors.black,
              size: 24.0.sp,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
