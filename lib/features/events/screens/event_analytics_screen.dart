import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/event.dart';

class EventAnalyticsScreen extends StatefulWidget {
  final Event event;

  const EventAnalyticsScreen({super.key, required this.event});

  @override
  State<EventAnalyticsScreen> createState() => _EventAnalyticsScreenState();
}

class _EventAnalyticsScreenState extends State<EventAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewSection(context),
                      SizedBox(height: 24.h),
                      _buildParticipationSection(context),
                      SizedBox(height: 24.h),
                      _buildResponseSection(context),
                      SizedBox(height: 24.h),
                      if (widget.event.minAge != null ||
                          widget.event.maxAge != null)
                        _buildAgeDistributionSection(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          _buildOverviewItem(
            context,
            icon: CupertinoIcons.person_2_fill,
            label: 'Total Participants',
            value: widget.event.participants.length.toString(),
            color: AppColors.success,
          ),
          if (widget.event.hasWaitlist) ...[
            SizedBox(height: 12.h),
            _buildOverviewItem(
              context,
              icon: CupertinoIcons.person_2,
              label: 'Waitlist',
              value: widget.event.waitlist.length.toString(),
              color: AppColors.warning,
            ),
          ],
          SizedBox(height: 12.h),
          _buildOverviewItem(
            context,
            icon: CupertinoIcons.person_crop_circle_badge_xmark,
            label: 'Declined',
            value: '0', // TODO: Add declined count
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gender Distribution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showParticipantDetails(context),
                child: Text(
                  'View Details',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return CustomPaint(
                          size: Size.square(200.w),
                          painter: GenderDistributionPainter(
                            male: 10, // TODO: Replace with actual gender counts
                            female: 15,
                            other: 5,
                            animationValue: value,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(context, 'Male', AppColors.primary),
                        _buildLegendItem(context, 'Female', AppColors.accent),
                        _buildLegendItem(context, 'Other', AppColors.success),
                      ],
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

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showParticipantDetails(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => ParticipantDetailsSheet(event: widget.event),
    );
  }

  Widget _buildResponseSection(BuildContext context) {
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
            'Responses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 16.h),
          _buildResponseItem(
            context,
            label: 'Going',
            count: widget.event.participants.length,
            color: AppColors.success,
          ),
          SizedBox(height: 12.h),
          _buildResponseItem(
            context,
            label: 'Maybe',
            count: 0, // TODO: Add maybe count
            color: AppColors.warning,
          ),
          SizedBox(height: 12.h),
          _buildResponseItem(
            context,
            label: 'Not Going',
            count: 0, // TODO: Add not going count
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: color,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildResponseItem(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAgeDistributionSection(BuildContext context) {
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
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                        height: 1.3,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAgeRange() {
    if (widget.event.minAge != null && widget.event.maxAge != null) {
      return '${widget.event.minAge} - ${widget.event.maxAge} years';
    } else if (widget.event.minAge != null) {
      return '${widget.event.minAge}+ years';
    } else if (widget.event.maxAge != null) {
      return 'Up to ${widget.event.maxAge} years';
    }
    return 'All ages';
  }
}

class GenderDistributionPainter extends CustomPainter {
  final int male;
  final int female;
  final int other;
  final double animationValue;

  GenderDistributionPainter({
    required this.male,
    required this.female,
    required this.other,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final total = male + female + other;
    if (total == 0) return;

    final malePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final femalePaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    final otherPaint = Paint()
      ..color = AppColors.success
      ..style = PaintingStyle.fill;

    final maleAngle = (male / total) * 2 * 3.14159 * animationValue;
    final femaleAngle = (female / total) * 2 * 3.14159 * animationValue;
    final otherAngle = (other / total) * 2 * 3.14159 * animationValue;

    var startAngle = -1.5708; // Start from top (-90 degrees)

    canvas.drawArc(rect, startAngle, maleAngle, true, malePaint);
    startAngle += maleAngle;

    canvas.drawArc(rect, startAngle, femaleAngle, true, femalePaint);
    startAngle += femaleAngle;

    canvas.drawArc(rect, startAngle, otherAngle, true, otherPaint);
  }

  @override
  bool shouldRepaint(covariant GenderDistributionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticipantDetailsSheet extends StatelessWidget {
  final Event event;

  const ParticipantDetailsSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          'Participant Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      child: SafeArea(
        child: DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Container(
                color: AppColors.surface,
                child: TabBar(
                  labelColor: AppColors.accent,
                  unselectedLabelColor: AppColors.textLight,
                  indicatorColor: AppColors.accent,
                  tabs: [
                    Tab(
                        text:
                            'All (${event.participants.length + event.waitlist.length})'),
                    Tab(text: 'Going (${event.participants.length})'),
                    if (event.hasWaitlist)
                      Tab(text: 'Waitlist (${event.waitlist.length})'),
                    Tab(text: 'Declined (0)'), // TODO: Add declined count
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildParticipantList(
                        context, [...event.participants, ...event.waitlist]),
                    _buildParticipantList(context, event.participants),
                    if (event.hasWaitlist)
                      _buildParticipantList(context, event.waitlist),
                    _buildParticipantList(
                        context, []), // TODO: Add declined list
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantList(
      BuildContext context, List<String> participants) {
    if (participants.isEmpty) {
      return Center(
        child: Text(
          'No participants',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
                height: 1.3,
              ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemCount: participants.length,
      separatorBuilder: (context, index) => Divider(height: 20.h),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  CupertinoIcons.person_fill,
                  size: 20.sp,
                  color: AppColors.accent,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participants[index], // TODO: Replace with actual user name
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'user@example.com', // TODO: Replace with actual user email
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textLight,
                          height: 1.3,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
