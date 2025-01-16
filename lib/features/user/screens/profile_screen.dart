import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import 'edit_profile_screen.dart';
import 'notification_preferences_screen.dart';
import 'privacy_settings_screen.dart';
import 'app_settings_screen.dart';
import 'connected_accounts_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text('Profile'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildProfileHeader(context),
              SizedBox(height: 24.h),
              _buildSettingsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              CupertinoIcons.person_fill,
              size: 60.sp,
              color: AppColors.accent,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'John Doe',
          style: AppTypography.titleMedium,
        ),
        SizedBox(height: 4.h),
        Text(
          'San Francisco, CA',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textLight,
          ),
        ),
        SizedBox(height: 16.h),
        CupertinoButton(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(25.r),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const EditProfileScreen(),
              ),
            );
          },
          child: Text(
            'Edit Profile',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
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
              _buildSettingsTile(
                context,
                'Notifications',
                'Manage your notification preferences',
                CupertinoIcons.bell_fill,
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const NotificationPreferencesScreen(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                'Privacy',
                'Control your privacy settings',
                CupertinoIcons.lock_fill,
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const PrivacySettingsScreen(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                'Connected Accounts',
                'Manage your connected accounts',
                CupertinoIcons.link,
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ConnectedAccountsScreen(),
                  ),
                ),
              ),
              _buildDivider(),
              _buildSettingsTile(
                context,
                'App Settings',
                'Customize your app experience',
                CupertinoIcons.settings_solid,
                () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AppSettingsScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Icon(
                icon,
                color: AppColors.accent,
                size: 20.sp,
              ),
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: 20.sp,
            color: AppColors.textLight,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: AppColors.textLight.withOpacity(0.1),
    );
  }
}
