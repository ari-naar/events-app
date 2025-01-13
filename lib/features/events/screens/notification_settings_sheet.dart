import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class NotificationSettings {
  final bool reminderEnabled;
  final Duration reminderBefore;
  final bool responseReminderEnabled;
  final Duration responseReminderBefore;

  const NotificationSettings({
    this.reminderEnabled = true,
    this.reminderBefore = const Duration(hours: 24),
    this.responseReminderEnabled = true,
    this.responseReminderBefore = const Duration(days: 3),
  });

  NotificationSettings copyWith({
    bool? reminderEnabled,
    Duration? reminderBefore,
    bool? responseReminderEnabled,
    Duration? responseReminderBefore,
  }) {
    return NotificationSettings(
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderBefore: reminderBefore ?? this.reminderBefore,
      responseReminderEnabled:
          responseReminderEnabled ?? this.responseReminderEnabled,
      responseReminderBefore:
          responseReminderBefore ?? this.responseReminderBefore,
    );
  }
}

class NotificationSettingsSheet extends StatefulWidget {
  final NotificationSettings initialSettings;

  const NotificationSettingsSheet({
    super.key,
    this.initialSettings = const NotificationSettings(),
  });

  static Future<NotificationSettings?> show(
    BuildContext context, {
    NotificationSettings initialSettings = const NotificationSettings(),
  }) {
    return showModalBottomSheet<NotificationSettings>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationSettingsSheet(
        initialSettings: initialSettings,
      ),
    );
  }

  @override
  State<NotificationSettingsSheet> createState() =>
      _NotificationSettingsSheetState();
}

class _NotificationSettingsSheetState extends State<NotificationSettingsSheet> {
  late NotificationSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEventReminderSection(),
                      SizedBox(height: 24.h),
                      _buildResponseReminderSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
          Text(
            'Notifications',
            style: AppTypography.titleMedium,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context, _settings),
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
    );
  }

  Widget _buildEventReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Reminder',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enable Reminder',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _settings.reminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          _settings =
                              _settings.copyWith(reminderEnabled: value);
                        });
                      },
                      activeTrackColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_settings.reminderEnabled) ...[
                Divider(
                    height: 1.h,
                    color: AppColors.textLight.withValues(alpha: 0.1)),
                CupertinoButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  onPressed: () => _showDurationPicker(
                    initialDuration: _settings.reminderBefore,
                    onChanged: (duration) {
                      setState(() {
                        _settings =
                            _settings.copyWith(reminderBefore: duration);
                      });
                    },
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remind Before',
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        _formatDuration(_settings.reminderBefore),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponseReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Response Reminder',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enable Response Reminder',
                      style: AppTypography.bodyMedium,
                    ),
                    CupertinoSwitch(
                      value: _settings.responseReminderEnabled,
                      onChanged: (value) {
                        setState(() {
                          _settings = _settings.copyWith(
                              responseReminderEnabled: value);
                        });
                      },
                      activeTrackColor: AppColors.accent,
                    ),
                  ],
                ),
              ),
              if (_settings.responseReminderEnabled) ...[
                Divider(
                    height: 1.h,
                    color: AppColors.textLight.withValues(alpha: 0.1)),
                CupertinoButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  onPressed: () => _showDurationPicker(
                    initialDuration: _settings.responseReminderBefore,
                    onChanged: (duration) {
                      setState(() {
                        _settings = _settings.copyWith(
                            responseReminderBefore: duration);
                      });
                    },
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Remind Before',
                        style: AppTypography.bodyMedium,
                      ),
                      Text(
                        _formatDuration(_settings.responseReminderBefore),
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _showDurationPicker({
    required Duration initialDuration,
    required ValueChanged<Duration> onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200.h,
        color: AppColors.background,
        child: CupertinoPicker(
          itemExtent: 32.h,
          onSelectedItemChanged: (index) {
            final durations = [
              const Duration(hours: 1),
              const Duration(hours: 2),
              const Duration(hours: 4),
              const Duration(hours: 8),
              const Duration(hours: 12),
              const Duration(hours: 24),
              const Duration(days: 2),
              const Duration(days: 3),
              const Duration(days: 5),
              const Duration(days: 7),
            ];
            onChanged(durations[index]);
          },
          children: [
            '1 hour before',
            '2 hours before',
            '4 hours before',
            '8 hours before',
            '12 hours before',
            '24 hours before',
            '2 days before',
            '3 days before',
            '5 days before',
            '7 days before',
          ].map((text) => Center(child: Text(text))).toList(),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} ${duration.inDays == 1 ? 'day' : 'days'} before';
    } else {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hour' : 'hours'} before';
    }
  }
}
