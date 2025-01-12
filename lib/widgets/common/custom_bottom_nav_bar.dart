import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/app_colors.dart';

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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: (64 + bottomPadding).h,
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.navBarBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(HugeIcons.strokeRoundedHome05, 0),
          _buildNavItem(HugeIcons.strokeRoundedSearch01, 1),
          _buildNavItem(HugeIcons.strokeRoundedPencilEdit02, 2),
          _buildNavItem(HugeIcons.strokeRoundedCalendar01, 3),
          _buildNavItem(HugeIcons.strokeRoundedUserCircle, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48.w,
        height: 48.h,
        child: Center(
          child: Icon(
            icon,
            size: 24.sp,
            color: isSelected ? AppColors.accent : AppColors.navBarUnselected,
          ),
        ),
      ),
    );
  }
}
