import 'dart:math' show cos, sin, pi;
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
                      _buildResponseSection(context),
                      SizedBox(height: 24.h),
                      if (widget.event.minAge != null ||
                          widget.event.maxAge != null)
                        _buildAgeDistributionSection(context),
                      SizedBox(height: 24.h),
                      _buildParticipationSection(context),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            'Gender Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                            male: 10,
                            female: 15,
                            other: 5,
                            animationValue: value,
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
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
                        _buildLegendItem(
                            context, 'Male (10)', AppColors.primary),
                        _buildLegendItem(
                            context, 'Female (15)', AppColors.accent),
                        _buildLegendItem(
                            context, 'Other (5)', AppColors.success),
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
            color: color.withValues(alpha: 0.1),
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
              color: AppColors.accent.withValues(alpha: 0.1),
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
  final TextStyle textStyle;

  GenderDistributionPainter({
    required this.male,
    required this.female,
    required this.other,
    required this.animationValue,
    required this.textStyle,
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

    final maleAngle = (male / total) * 2 * pi * animationValue;
    final femaleAngle = (female / total) * 2 * pi * animationValue;
    final otherAngle = (other / total) * 2 * pi * animationValue;

    var startAngle = -pi / 2; // Start from top (-90 degrees)

    // Draw arcs
    canvas.drawArc(rect, startAngle, maleAngle, true, malePaint);
    _drawText(canvas, center, startAngle + maleAngle / 2, radius * 0.7,
        male.toString(), textStyle);
    startAngle += maleAngle;

    canvas.drawArc(rect, startAngle, femaleAngle, true, femalePaint);
    _drawText(canvas, center, startAngle + femaleAngle / 2, radius * 0.7,
        female.toString(), textStyle);
    startAngle += femaleAngle;

    canvas.drawArc(rect, startAngle, otherAngle, true, otherPaint);
    _drawText(canvas, center, startAngle + otherAngle / 2, radius * 0.7,
        other.toString(), textStyle);
  }

  void _drawText(Canvas canvas, Offset center, double angle, double radius,
      String text, TextStyle style) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final x = center.dx + radius * cos(angle) - textPainter.width / 2;
    final y = center.dy + radius * sin(angle) - textPainter.height / 2;

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant GenderDistributionPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticipantDetailsSheet extends StatefulWidget {
  final Event event;

  const ParticipantDetailsSheet({super.key, required this.event});

  @override
  State<ParticipantDetailsSheet> createState() =>
      _ParticipantDetailsSheetState();
}

class _ParticipantDetailsSheetState extends State<ParticipantDetailsSheet> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    final List<(String, int)> segments = [
      ('All', widget.event.participants.length + widget.event.waitlist.length),
      ('Going', widget.event.participants.length),
      ('Declined', 0), // TODO: Add declined count
      if (widget.event.hasWaitlist) ('Waitlist', widget.event.waitlist.length),
    ];

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Done',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
          ),
        ),
        middle: Text(
          'Participants',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 44.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  for (int i = 0; i < segments.length; i++) ...[
                    if (i > 0) SizedBox(width: 24.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSegment = i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              segments[i].$1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: _selectedSegment == i
                                        ? AppColors.textPrimary
                                        : AppColors.textLight,
                                    fontWeight: _selectedSegment == i
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    height: 1.3,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              segments[i].$2.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: _selectedSegment == i
                                        ? AppColors.accent
                                        : AppColors.textLight
                                            .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                            ),
                            SizedBox(height: 4.h),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 2.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: _selectedSegment == i
                                    ? AppColors.accent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(1.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.only(top: 8.h),
              color: AppColors.textLight.withValues(alpha: 0.1),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildParticipantList(
                  context,
                  _getParticipantsForSegment(_selectedSegment),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getParticipantsForSegment(int segment) {
    switch (segment) {
      case 0:
        return [...widget.event.participants, ...widget.event.waitlist];
      case 1:
        return widget.event.participants;
      case 2:
        return []; // TODO: Add declined list
      case 3:
        return widget.event.hasWaitlist ? widget.event.waitlist : [];
      default:
        return [];
    }
  }

  Widget _buildParticipantList(
      BuildContext context, List<String> participants) {
    if (participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_2_fill,
              size: 48.sp,
              color: AppColors.textLight.withValues(alpha: 0.2),
            ),
            SizedBox(height: 16.h),
            Text(
              'No participants yet',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textLight,
                    height: 1.3,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Share the event to get people involved',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.7),
                    height: 1.3,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final bool isLast = index == participants.length - 1;
        return Column(
          children: [
            CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              onPressed: () {
                // TODO: Show participant details
              },
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 24.sp,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          participants[
                              index], // TODO: Replace with actual user name
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'user@example.com', // TODO: Replace with actual user email
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textLight,
                                    height: 1.3,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 16.sp,
                    color: AppColors.textLight,
                  ),
                ],
              ),
            ),
            if (!isLast)
              Padding(
                padding: EdgeInsets.only(left: 64.w),
                child: Divider(
                  height: 1.h,
                  color: AppColors.textLight.withValues(alpha: 0.1),
                ),
              ),
          ],
        );
      },
    );
  }
}
