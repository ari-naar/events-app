import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_typography.dart';
import '../../../widgets/events/event_card.dart';
import '../../../core/models/event.dart';
import 'event_details_screen.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual event data from service
    final List<Event> events = [
      Event(
        id: '1',
        name: 'Summer Beach Party',
        date: DateTime.now().add(const Duration(days: 2)),
        location: 'Miami Beach',
        minParticipants: 10,
        maxParticipants: 50,
        responseCutoff: DateTime.now().add(const Duration(days: 1)),
        participants: List.generate(30, (index) => 'user$index'),
      ),
      // Add more sample events here
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events',
          style: AppTypography.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering
            },
          ),
        ],
      ),
      body: GridView.builder(
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
                  builder: (context) => EventDetailsScreen(eventId: event.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
