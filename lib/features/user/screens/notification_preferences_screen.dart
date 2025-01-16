import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _eventInvites = true;
  bool _eventReminders = true;
  bool _eventUpdates = true;
  bool _rsvpUpdates = true;
  bool _friendActivity = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text('Notification Settings'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationTypesSection(),
              SizedBox(height: 24.h),
              _buildNotificationMethodsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Types',
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
                title: 'Event Invites',
                subtitle: 'When you are invited to an event',
                value: _eventInvites,
                onChanged: (value) => setState(() => _eventInvites = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Event Reminders',
                subtitle: 'Reminders for upcoming events',
                value: _eventReminders,
                onChanged: (value) => setState(() => _eventReminders = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Event Updates',
                subtitle: 'When event details change',
                value: _eventUpdates,
                onChanged: (value) => setState(() => _eventUpdates = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'RSVP Updates',
                subtitle: 'When people respond to your events',
                value: _rsvpUpdates,
                onChanged: (value) => setState(() => _rsvpUpdates = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Friend Activity',
                subtitle: 'When friends create or join events',
                value: _friendActivity,
                onChanged: (value) => setState(() => _friendActivity = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationMethodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Methods',
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
                title: 'Push Notifications',
                subtitle: 'Receive notifications on your device',
                value: _pushNotifications,
                onChanged: (value) =>
                    setState(() => _pushNotifications = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive notifications via email',
                value: _emailNotifications,
                onChanged: (value) =>
                    setState(() => _emailNotifications = value),
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

  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      color: AppColors.textLight.withOpacity(0.1),
    );
  }
}
