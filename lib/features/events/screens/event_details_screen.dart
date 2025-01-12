import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/event.dart';
import '../../../core/models/event_category.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventInfo(context),
                  SizedBox(height: 24.h),
                  _buildParticipantsSection(context),
                  SizedBox(height: 24.h),
                  _buildDetailsSection(context),
                  SizedBox(height: 24.h),
                  _buildLocationSection(context),
                  SizedBox(height: 32.h),
                  _buildActionButtons(context),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.h,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.pop(context),
        child: Container(
          margin: EdgeInsets.only(left: 16.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            CupertinoIcons.back,
            color: AppColors.textLight,
            size: 20.sp,
          ),
        ),
      ),
      actions: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            // TODO: Implement share
          },
          child: Container(
            margin: EdgeInsets.only(right: 16.w),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.share,
              color: AppColors.textLight,
              size: 20.sp,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              event.category?.image ?? EventCategory.other.image,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: event.category?.color.withOpacity(0.1) ??
                      AppColors.surface,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        event.category?.color ?? AppColors.accent,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: event.category?.color.withOpacity(0.1) ??
                      AppColors.surface,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          event.category?.icon ?? Icons.category,
                          size: 48.sp,
                          color: event.category?.color ?? AppColors.textLight,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          event.category?.label ?? 'Event',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: event.category?.color ??
                                        AppColors.textLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: event.category?.color.withOpacity(0.9) ??
                          EventCategory.other.color.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      event.category?.label ?? 'Other',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: CupertinoIcons.calendar,
            title: 'Date & Time',
            value: _formatDateTime(event.date),
          ),
          if (event.responseCutoff != null) ...[
            Divider(height: 20.h),
            _buildInfoRow(
              context,
              icon: CupertinoIcons.time,
              title: 'Response Cutoff',
              value: _formatDateTime(event.responseCutoff!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participants',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildParticipantCount(
                context,
                count: event.participants.length,
                total: event.maxParticipants,
                label: 'Going',
              ),
              if (event.hasWaitlist) ...[
                SizedBox(width: 24.w),
                _buildParticipantCount(
                  context,
                  count: event.waitlist.length,
                  label: 'Waitlist',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 12.h),
          if (event.description?.isNotEmpty ?? false)
            Text(
              event.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (event.minAge != null || event.maxAge != null) ...[
            SizedBox(height: 16.h),
            _buildInfoRow(
              context,
              icon: CupertinoIcons.person_2,
              title: 'Age Range',
              value: _formatAgeRange(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                CupertinoIcons.location_solid,
                size: 20.sp,
                color: AppColors.accent,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  event.location,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'Map',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textLight.withOpacity(0.2),
                          ),
                    ),
                  ),
                  Positioned(
                    right: 12.w,
                    bottom: 12.h,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        // TODO: Implement directions
                      },
                      backgroundColor: AppColors.accent,
                      child: Icon(
                        CupertinoIcons.location_fill,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final bool canJoin = event.maxParticipants == null ||
        event.participants.length < (event.maxParticipants ?? 0);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: CupertinoButton(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            color: canJoin ? AppColors.accent : AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            onPressed: canJoin
                ? () {
                    // TODO: Implement join event
                  }
                : null,
            child: Text(
              canJoin ? 'Join Event' : 'Event Full',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: canJoin ? Colors.white : AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        if (!canJoin && event.hasWaitlist) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              onPressed: () {
                // TODO: Implement join waitlist
              },
              child: Text(
                'Join Waitlist',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColors.accent,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textLight,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCount(
    BuildContext context, {
    required int count,
    int? total,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              total != null ? '$count/$total' : count.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textLight,
              ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final time = TimeOfDay.fromDateTime(dateTime);
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year} $hour:$minute $period';
  }

  String _formatAgeRange() {
    if (event.minAge != null && event.maxAge != null) {
      return '${event.minAge} - ${event.maxAge} years';
    } else if (event.minAge != null) {
      return '${event.minAge}+ years';
    } else if (event.maxAge != null) {
      return 'Up to ${event.maxAge} years';
    }
    return 'All ages';
  }
}
