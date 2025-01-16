import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';

class ConnectedAccountsScreen extends StatefulWidget {
  const ConnectedAccountsScreen({super.key});

  @override
  State<ConnectedAccountsScreen> createState() =>
      _ConnectedAccountsScreenState();
}

class _ConnectedAccountsScreenState extends State<ConnectedAccountsScreen> {
  final Map<String, bool> _connectedAccounts = {
    'Google': true,
    'Apple': false,
    'Facebook': true,
    'Twitter': false,
  };

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        middle: Text('Connected Accounts'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoMessage(),
              SizedBox(height: 24.h),
              _buildSocialAccountsSection(),
              SizedBox(height: 24.h),
              _buildCalendarSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoMessage() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.info_circle_fill,
            color: AppColors.accent,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Connect your accounts to easily share events and sync your calendar.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Accounts',
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
              _buildAccountTile(
                'Google',
                'assets/icons/google.png',
                _connectedAccounts['Google']!,
                onTap: () => _handleAccountConnection('Google'),
              ),
              _buildDivider(),
              _buildAccountTile(
                'Apple',
                'assets/icons/apple.png',
                _connectedAccounts['Apple']!,
                onTap: () => _handleAccountConnection('Apple'),
              ),
              _buildDivider(),
              _buildAccountTile(
                'Facebook',
                'assets/icons/facebook.png',
                _connectedAccounts['Facebook']!,
                onTap: () => _handleAccountConnection('Facebook'),
              ),
              _buildDivider(),
              _buildAccountTile(
                'Twitter',
                'assets/icons/twitter.png',
                _connectedAccounts['Twitter']!,
                onTap: () => _handleAccountConnection('Twitter'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calendar Integration',
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
              _buildAccountTile(
                'Apple Calendar',
                'assets/icons/calendar.png',
                false,
                onTap: () => _handleCalendarConnection('apple'),
              ),
              _buildDivider(),
              _buildAccountTile(
                'Google Calendar',
                'assets/icons/google_calendar.png',
                true,
                onTap: () => _handleCalendarConnection('google'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTile(
    String title,
    String iconPath,
    bool isConnected, {
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      onPressed: onTap,
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 20.w,
                height: 20.w,
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
                  isConnected ? 'Connected' : 'Not connected',
                  style: AppTypography.bodySmall.copyWith(
                    color:
                        isConnected ? AppColors.success : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isConnected
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.plus_circle_fill,
            color: isConnected ? AppColors.success : AppColors.accent,
            size: 24.sp,
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

  Future<void> _handleAccountConnection(String platform) async {
    // TODO: Implement social account connection
    setState(() {
      _connectedAccounts[platform] = !_connectedAccounts[platform]!;
    });
  }

  Future<void> _handleCalendarConnection(String platform) async {
    // TODO: Implement calendar integration
  }
}
