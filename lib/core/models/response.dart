import 'package:flutter/foundation.dart';

enum ResponseStatus { attending, notAttending, waitlist, pending }

class EventResponse {
  final String id;
  final String eventId;
  final String userId;
  final ResponseStatus status;
  final DateTime responseTime;
  final String? note;

  EventResponse({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.status,
    required this.responseTime,
    this.note,
  });

  EventResponse copyWith({
    String? id,
    String? eventId,
    String? userId,
    ResponseStatus? status,
    DateTime? responseTime,
    String? note,
  }) {
    return EventResponse(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      responseTime: responseTime ?? this.responseTime,
      note: note ?? this.note,
    );
  }
}
