import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profilePublic = true;
  bool _showLocation = true;
  bool _showEvents = true;
  bool _allowFriendRequests = true;
  bool _showInSearch = true;
  String _defaultEventPrivacy = 'Public';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text('Privacy Settings'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilePrivacySection(),
              SizedBox(height: 24.h),
              _buildEventPrivacySection(),
              SizedBox(height: 24.h),
              _buildDataPrivacySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Privacy',
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
              _buildSwitchTile(
                title: 'Public Profile',
                subtitle: 'Anyone can view your profile',
                value: _profilePublic,
                onChanged: (value) => setState(() => _profilePublic = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Show Location',
                subtitle: 'Display your location on your profile',
                value: _showLocation,
                onChanged: (value) => setState(() => _showLocation = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Show in Search',
                subtitle: 'Allow others to find you in search',
                value: _showInSearch,
                onChanged: (value) => setState(() => _showInSearch = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Privacy',
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
              _buildSwitchTile(
                title: 'Show Events',
                subtitle: 'Show events you\'re attending on your profile',
                value: _showEvents,
                onChanged: (value) => setState(() => _showEvents = value),
              ),
              _buildDivider(),
              _buildPickerTile(
                title: 'Default Event Privacy',
                subtitle: 'Default privacy setting for new events',
                value: _defaultEventPrivacy,
                onTap: _showEventPrivacyPicker,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data & Privacy',
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
              _buildActionTile(
                title: 'Download Your Data',
                subtitle: 'Get a copy of your data',
                onTap: () {
                  // TODO: Implement download data
                },
              ),
              _buildDivider(),
              _buildActionTile(
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and data',
                isDestructive: true,
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
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
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerTile({
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        children: [
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
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                CupertinoIcons.chevron_right,
                size: 20.sp,
                color: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? AppColors.error : null,
                  ),
                ),
                SizedBox(height: 4.h),
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

  void _showEventPrivacyPicker() {
    final options = ['Public', 'Private', 'Invite Only'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 300.h,
        color: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.textLight.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Done',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40.h,
                onSelectedItemChanged: (index) {
                  setState(() => _defaultEventPrivacy = options[index]);
                },
                children: options
                    .map(
                      (option) => Center(
                        child: Text(
                          option,
                          style: AppTypography.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
            },
            child: const Text('Delete'),
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
