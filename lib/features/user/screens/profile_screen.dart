import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Profile'),
            backgroundColor: AppColors.background,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 24.h),
                  _buildUserInfoSection(),
                  SizedBox(height: 24.h),
                  _buildEventHistorySection(),
                  SizedBox(height: 24.h),
                  _buildSettingsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.person_fill,
                size: 48.sp,
                color: AppColors.accent,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'John Doe',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'john.doe@example.com',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          SizedBox(height: 16.h),
          CupertinoButton(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            onPressed: () {
              // TODO: Implement edit profile
            },
            child: Text(
              'Edit Profile',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Information',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: CupertinoIcons.phone,
                title: 'Phone',
                value: '+1 234 567 8900',
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.calendar,
                title: 'Date of Birth',
                value: 'January 1, 1990',
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.location_solid,
                title: 'Location',
                value: 'San Francisco, CA',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event History',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: CupertinoIcons.star_fill,
                title: 'Hosted Events',
                value: '12 events',
                onTap: () {
                  // TODO: Navigate to hosted events
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.person_2_fill,
                title: 'Events Attended',
                value: '34 events',
                onTap: () {
                  // TODO: Navigate to attended events
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.titleSmall,
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: CupertinoIcons.bell_fill,
                title: 'Notifications',
                showChevron: true,
                onTap: () {
                  // TODO: Navigate to notification settings
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.lock_fill,
                title: 'Privacy',
                showChevron: true,
                onTap: () {
                  // TODO: Navigate to privacy settings
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.person_crop_circle_fill_badge_plus,
                title: 'Connected Accounts',
                showChevron: true,
                onTap: () {
                  // TODO: Navigate to connected accounts
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.gear_alt_fill,
                title: 'App Settings',
                showChevron: true,
                onTap: () {
                  // TODO: Navigate to app settings
                },
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: CupertinoIcons.square_arrow_right,
                title: 'Sign Out',
                titleColor: AppColors.error,
                onTap: () {
                  _showSignOutDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    String? value,
    Color? titleColor,
    bool showChevron = false,
    VoidCallback? onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: AppColors.accent,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: titleColor ?? AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (value != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                CupertinoIcons.chevron_right,
                size: 20.sp,
                color: AppColors.textLight,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: AppColors.textLight.withOpacity(0.1),
    );
  }

  void _showSignOutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out
            },
            child: const Text('Sign Out'),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
