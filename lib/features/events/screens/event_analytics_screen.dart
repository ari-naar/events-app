import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/event.dart';
import 'package:fl_chart/fl_chart.dart';

class EventAnalyticsScreen extends StatelessWidget {
  final Event event;

  const EventAnalyticsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          'Event Analytics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOverviewSection(context),
                    SizedBox(height: 24.h),
                    _buildParticipationChart(context),
                    SizedBox(height: 24.h),
                    _buildResponseTimeline(context),
                    SizedBox(height: 24.h),
                    _buildAgeDistribution(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
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
            'Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Participants',
                  event.participants.length.toString(),
                  AppColors.success,
                ),
              ),
              SizedBox(width: 12.w),
              if (event.hasWaitlist)
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Waitlist',
                    event.waitlist.length.toString(),
                    AppColors.warning,
                  ),
                ),
            ],
          ),
          if (event.maxParticipants != null) ...[
            SizedBox(height: 12.h),
            _buildProgressBar(
              context,
              event.participants.length,
              event.maxParticipants!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipationChart(BuildContext context) {
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
            'Participation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 24.h),
          AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: event.participants.length.toDouble(),
                    title: 'Going',
                    color: AppColors.success,
                    radius: 80.r,
                    titleStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (event.hasWaitlist)
                    PieChartSectionData(
                      value: event.waitlist.length.toDouble(),
                      title: 'Waitlist',
                      color: AppColors.warning,
                      radius: 80.r,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseTimeline(BuildContext context) {
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
            'Response Timeline',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 24.h),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(2.5, event.participants.length / 2),
                      FlSpot(5, event.participants.length.toDouble()),
                    ],
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withOpacity(0.1),
                    ),
                  ),
                ],
                minY: 0,
                maxY: event.maxParticipants?.toDouble() ??
                    event.participants.length.toDouble(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeDistribution(BuildContext context) {
    if (event.minAge == null && event.maxAge == null) {
      return const SizedBox.shrink();
    }

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
            'Age Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.person_2,
                  size: 16.sp,
                  color: AppColors.accent,
                ),
                SizedBox(width: 8.w),
                Text(
                  _formatAgeRange(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, int current, int total) {
    final double progress = current / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Capacity',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
            Text(
              '$current/$total',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: FractionallySizedBox(
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
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
