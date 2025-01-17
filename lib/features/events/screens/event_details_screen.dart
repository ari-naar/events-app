import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/event.dart';
import '../../../core/models/event_category.dart';
import 'event_analytics_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        bool shouldShowTitle = _scrollController.offset > 200.h;
        if (shouldShowTitle != _showTitle) {
          setState(() => _showTitle = shouldShowTitle);
          if (shouldShowTitle) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: CustomScrollView(
        controller: _scrollController,
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
                  _buildLocationSection(context),
                  SizedBox(height: 24.h),
                  _buildDetailsSection(context),
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
      centerTitle: true,
      title: FadeTransition(
        opacity: _animationController,
        child: Text(
          widget.event.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(_showTitle ? 0 : 0.95),
              shape: BoxShape.circle,
              boxShadow: [
                if (!_showTitle)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Icon(
              CupertinoIcons.back,
              color: AppColors.textPrimary,
              size: 18.sp,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_showTitle ? 0 : 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  if (!_showTitle)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Icon(
                CupertinoIcons.chart_bar_alt_fill,
                color: AppColors.textPrimary,
                size: 18.sp,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      EventAnalyticsScreen(event: widget.event),
                ),
              );
            },
          ),
        ),
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(_showTitle ? 0 : 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  if (!_showTitle)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Icon(
                CupertinoIcons.share,
                color: AppColors.textPrimary,
                size: 18.sp,
              ),
            ),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ),
        SizedBox(width: 8.w),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'event_image_${widget.event.id}',
              child: Image.network(
                widget.event.category?.image ?? EventCategory.other.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: widget.event.category?.color.withOpacity(0.1) ??
                        AppColors.surface,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.event.category?.color ?? AppColors.accent,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: widget.event.category?.color.withOpacity(0.1) ??
                        AppColors.surface,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.event.category?.icon ?? Icons.category,
                            size: 48.sp,
                            color: widget.event.category?.color ??
                                AppColors.textLight,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            widget.event.category?.label ?? 'Event',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: widget.event.category?.color ??
                                      AppColors.textLight,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color:
                              widget.event.category?.color.withOpacity(0.9) ??
                                  EventCategory.other.color.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.event.category?.icon ?? Icons.category,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              widget.event.category?.label ?? 'Other',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    widget.event.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
            value: _formatDateTime(widget.event.date),
          ),
          if (widget.event.responseCutoff != null) ...[
            Divider(height: 20.h),
            _buildInfoRow(
              context,
              icon: CupertinoIcons.time,
              title: 'Response Cutoff',
              value: _formatDateTime(widget.event.responseCutoff),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Participants',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (widget.event.maxParticipants != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${widget.event.participants.length}/${widget.event.maxParticipants}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildParticipantCount(
                context,
                count: widget.event.participants.length,
                total: widget.event.maxParticipants,
                label: 'Going',
                color: AppColors.success,
              ),
              if (widget.event.hasWaitlist) ...[
                SizedBox(width: 24.w),
                _buildParticipantCount(
                  context,
                  count: widget.event.waitlist.length,
                  label: 'Waitlist',
                  color: AppColors.warning,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    if (!(widget.event.description?.isNotEmpty ?? false) &&
        widget.event.minAge == null &&
        widget.event.maxAge == null) {
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
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.event.description?.isNotEmpty ?? false) ...[
            SizedBox(height: 12.h),
            Text(
              widget.event.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
            ),
          ],
          if (widget.event.minAge != null || widget.event.maxAge != null) ...[
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
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    if (widget.event.location.isEmpty) {
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
                    height: 1.3,
                  ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.location_slash_fill,
                      size: 48.sp,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No location specified',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.textLight,
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
                  height: 1.3,
                ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  CupertinoIcons.location_solid,
                  size: 20.sp,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  widget.event.location,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.3,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              height: 200.h,
              width: double.infinity,
              child: FutureBuilder<List<Location>>(
                future: null,
                // future: locationFromAddress(widget.event.location),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final location = snapshot.data!.first;
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(widget.event.id),
                          position:
                              LatLng(location.latitude, location.longitude),
                        ),
                      },
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      color: AppColors.surface,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.map_fill,
                              size: 48.sp,
                              color: AppColors.textLight,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Could not load map',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.textLight,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container(
                    color: AppColors.surface,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showMapOptions(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.map_fill,
                    size: 20.sp,
                    color: AppColors.accent,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Open in Maps',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
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

  void _showMapOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Open Location In'),
        actions: [
          if (Platform.isIOS)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _openInMaps(widget.event.location, mapType: 'apple');
              },
              child: const Text('Apple Maps'),
            ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _openInMaps(widget.event.location, mapType: 'google');
            },
            child: const Text('Google Maps'),
          ),
          if (Platform.isIOS)
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _openInMaps(widget.event.location, mapType: 'waze');
              },
              child: const Text('Waze'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _openInMaps(String location, {required String mapType}) async {
    try {
      final encodedLocation = Uri.encodeComponent(location);
      String url;

      switch (mapType) {
        case 'apple':
          url = 'maps://?q=$encodedLocation';
          break;
        case 'google':
          url =
              'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
          break;
        case 'waze':
          url = 'waze://?q=$encodedLocation';
          break;
        default:
          url = Platform.isIOS
              ? 'maps://?q=$encodedLocation'
              : 'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('Could not open ${mapType.toUpperCase()} Maps'),
            content: Text(
                'Please make sure you have ${mapType.toUpperCase()} Maps installed.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Could not open the location in maps.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    final bool canJoin = widget.event.maxParticipants == null ||
        widget.event.participants.length < (widget.event.maxParticipants ?? 0);

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
                    height: 1.3,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (!canJoin && widget.event.hasWaitlist) ...[
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
                      height: 1.3,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                      height: 1.3,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildParticipantCount(
    BuildContext context, {
    required int count,
    int? total,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textLight,
                height: 1.3,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
