import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _darkMode = false;
  bool _useSystemTheme = true;
  String _language = 'English';
  String _timeZone = 'Auto';
  String _dateFormat = 'MM/DD/YYYY';
  String _timeFormat = '12-hour';
  bool _locationServices = true;
  bool _analytics = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text('App Settings'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppearanceSection(),
              SizedBox(height: 24.h),
              _buildLocalizationSection(),
              SizedBox(height: 24.h),
              _buildServicesSection(),
              SizedBox(height: 24.h),
              _buildAboutSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
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
                title: 'Use System Theme',
                subtitle: 'Match system dark/light mode',
                value: _useSystemTheme,
                onChanged: (value) => setState(() => _useSystemTheme = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Enable dark mode appearance',
                value: _darkMode,
                onChanged: _useSystemTheme
                    ? null
                    : (value) => setState(() => _darkMode = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Localization',
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
              _buildPickerTile(
                title: 'Language',
                subtitle: 'Choose your preferred language',
                value: _language,
                onTap: () => _showLanguagePicker(),
              ),
              _buildDivider(),
              _buildPickerTile(
                title: 'Time Zone',
                subtitle: 'Set your time zone',
                value: _timeZone,
                onTap: () => _showTimeZonePicker(),
              ),
              _buildDivider(),
              _buildPickerTile(
                title: 'Date Format',
                subtitle: 'Choose how dates are displayed',
                value: _dateFormat,
                onTap: () => _showDateFormatPicker(),
              ),
              _buildDivider(),
              _buildPickerTile(
                title: 'Time Format',
                subtitle: '12 or 24-hour clock',
                value: _timeFormat,
                onTap: () => _showTimeFormatPicker(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Services',
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
                title: 'Location Services',
                subtitle: 'Enable location-based features',
                value: _locationServices,
                onChanged: (value) => setState(() => _locationServices = value),
              ),
              _buildDivider(),
              _buildSwitchTile(
                title: 'Analytics',
                subtitle: 'Help improve the app by sharing usage data',
                value: _analytics,
                onChanged: (value) => setState(() => _analytics = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
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
                title: 'Version',
                subtitle: '1.0.0 (Build 100)',
                onTap: () {},
                showChevron: false,
              ),
              _buildDivider(),
              _buildActionTile(
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: () {
                  // TODO: Implement terms of service
                },
              ),
              _buildDivider(),
              _buildActionTile(
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // TODO: Implement privacy policy
                },
              ),
              _buildDivider(),
              _buildActionTile(
                title: 'Licenses',
                subtitle: 'Third-party licenses',
                onTap: () {
                  // TODO: Show licenses page
                },
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
    required ValueChanged<bool>? onChanged,
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
    bool showChevron = true,
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
          if (showChevron)
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

  void _showLanguagePicker() {
    final options = ['English', 'Spanish', 'French', 'German', 'Italian'];
    _showPicker(
        options, _language, (value) => setState(() => _language = value));
  }

  void _showTimeZonePicker() {
    final options = ['Auto', 'UTC', 'GMT', 'EST', 'PST', 'CST'];
    _showPicker(
        options, _timeZone, (value) => setState(() => _timeZone = value));
  }

  void _showDateFormatPicker() {
    final options = ['MM/DD/YYYY', 'DD/MM/YYYY', 'YYYY-MM-DD'];
    _showPicker(
        options, _dateFormat, (value) => setState(() => _dateFormat = value));
  }

  void _showTimeFormatPicker() {
    final options = ['12-hour', '24-hour'];
    _showPicker(
        options, _timeFormat, (value) => setState(() => _timeFormat = value));
  }

  void _showPicker(List<String> options, String currentValue,
      ValueChanged<String> onSelect) {
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
                onSelectedItemChanged: (index) => onSelect(options[index]),
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
}
