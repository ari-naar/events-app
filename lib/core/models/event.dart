import 'package:flutter/foundation.dart';
import 'event_category.dart';

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final String? description;
  final EventCategory? category;
  final int? minParticipants;
  final int? maxParticipants;
  final DateTime responseCutoff;
  final bool hasWaitlist;
  final List<String> participants;
  final List<String> waitlist;
  final int? minAge;
  final int? maxAge;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    this.description,
    this.category,
    this.minParticipants,
    this.maxParticipants,
    required this.responseCutoff,
    required this.hasWaitlist,
    required this.participants,
    required this.waitlist,
    this.minAge,
    this.maxAge,
  });

  Event copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? location,
    String? description,
    EventCategory? category,
    int? minParticipants,
    int? maxParticipants,
    DateTime? responseCutoff,
    bool? hasWaitlist,
    List<String>? participants,
    List<String>? waitlist,
    int? minAge,
    int? maxAge,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      description: description ?? this.description,
      category: category ?? this.category,
      minParticipants: minParticipants ?? this.minParticipants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      responseCutoff: responseCutoff ?? this.responseCutoff,
      hasWaitlist: hasWaitlist ?? this.hasWaitlist,
      participants: participants ?? this.participants,
      waitlist: waitlist ?? this.waitlist,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
    );
  }
}
