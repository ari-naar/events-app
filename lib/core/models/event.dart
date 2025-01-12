import 'package:flutter/foundation.dart';

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final int minParticipants;
  final int maxParticipants;
  final DateTime responseCutoff;
  final bool hasWaitlist;
  final List<String> participants;
  final List<String> waitlist;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.minParticipants,
    required this.maxParticipants,
    required this.responseCutoff,
    this.hasWaitlist = false,
    this.participants = const [],
    this.waitlist = const [],
  });

  Event copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? location,
    int? minParticipants,
    int? maxParticipants,
    DateTime? responseCutoff,
    bool? hasWaitlist,
    List<String>? participants,
    List<String>? waitlist,
  }) {
    return Event(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      location: location ?? this.location,
      minParticipants: minParticipants ?? this.minParticipants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      responseCutoff: responseCutoff ?? this.responseCutoff,
      hasWaitlist: hasWaitlist ?? this.hasWaitlist,
      participants: participants ?? this.participants,
      waitlist: waitlist ?? this.waitlist,
    );
  }
}
