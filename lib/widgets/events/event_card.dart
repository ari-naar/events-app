import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_typography.dart';
import '../../core/models/event.dart';
import '../../core/models/response.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final bool isAdmin;
  final ResponseStatus? userResponseStatus;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.isAdmin = false,
    this.userResponseStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.r)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.calendar,
                      size: 32.sp,
                      color: AppColors.textLight.withOpacity(0.5),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: _buildAttendanceChip(),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: AppTypography.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 16.sp,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatDateTime(event.date),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location,
                        size: 16.sp,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceChip() {
    if (isAdmin) {
      return _buildAdminChip();
    } else {
      return _buildUserStatusChip();
    }
  }

  Widget _buildAdminChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            HugeIcons.strokeRoundedUserStatus,
            size: 16.sp,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            '${event.participants.length}/${event.maxParticipants}',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatusChip() {
    Color chipColor;
    String statusText;
    IconData statusIcon;

    switch (userResponseStatus) {
      case ResponseStatus.attending:
        chipColor = AppColors.success;
        statusText = 'Attending';
        statusIcon = HugeIcons.strokeRoundedCheckmarkCircle02;
        break;
      case ResponseStatus.notAttending:
        chipColor = AppColors.error;
        statusText = 'Not Attending';
        statusIcon = HugeIcons.strokeRoundedCancelCircle;
        break;
      case ResponseStatus.maybe:
        chipColor = AppColors.warning;
        statusText = 'Maybe';
        statusIcon = HugeIcons.strokeRoundedLoading01;
        break;
      case ResponseStatus.waitlist:
        chipColor = AppColors.warning;
        statusText = 'Waitlist';
        statusIcon = HugeIcons.strokeRoundedLoading01;
        break;
      case ResponseStatus.pending:
      default:
        chipColor = AppColors.textLight;
        statusText = 'Pending';
        statusIcon = HugeIcons.strokeRoundedLoading01;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16.sp,
            color: Colors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            statusText,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
