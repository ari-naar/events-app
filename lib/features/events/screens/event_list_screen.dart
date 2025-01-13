import 'package:events_app/core/models/event_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../widgets/events/event_card.dart';
import '../../../core/models/event.dart';
import 'event_details_screen.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late DraggableScrollableController _dragController;

  @override
  void initState() {
    super.initState();
    _dragController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  void _handleDragTap() {
    if (_dragController.size <= 0.1) {
      _dragController.animateTo(
        0.6,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Event> events = [
      Event(
        id: '1',
        name: 'Summer Beach Party',
        date: DateTime.now().add(const Duration(days: 2)),
        location: 'Miami Beach',
        category: EventCategory.food,
        minParticipants: 10,
        maxParticipants: 50,
        responseCutoff: DateTime.now().add(const Duration(days: 1)),
        participants: List.generate(30, (index) => 'user$index'),
        hasWaitlist: true,
        waitlist: List.generate(10, (index) => 'waitlist$index'),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Map Background
          const Center(
            child: Text(
              'Map',
              style: TextStyle(
                fontSize: 48,
                color: Colors.black12,
              ),
            ),
          ),

          // Events Modal Sheet
          DraggableScrollableSheet(
            controller: _dragController,
            initialChildSize: 0.6,
            minChildSize: 0.1,
            maxChildSize: 0.99,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.r)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Interactive Header Area
                    GestureDetector(
                      onTap: _handleDragTap,
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: [
                          // Drag Handle
                          Container(
                            width: 40.w,
                            height: 4.h,
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color: AppColors.textLight.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),

                          // Header
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Events',
                                  style: AppTypography.titleMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  onPressed: () {
                                    // TODO: Implement filtering
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Events Grid
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailsScreen(event: event),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
