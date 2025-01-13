import 'event_category.dart';

enum EventType {
  inviteOnly('Invite Only', 'Only invited people can join'),
  private('Private', 'People can request to join'),
  public('Public', 'Anyone can join');

  final String label;
  final String description;

  const EventType(this.label, this.description);
}

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final int? minParticipants;
  final int? maxParticipants;
  final DateTime responseCutoff;
  final bool hasWaitlist;
  final List<String> participants;
  final List<String> waitlist;
  final int? minAge;
  final int? maxAge;
  final String? description;
  final EventCategory? category;
  final EventType type;

  const Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    this.minParticipants,
    this.maxParticipants,
    required this.responseCutoff,
    required this.hasWaitlist,
    required this.participants,
    required this.waitlist,
    this.minAge,
    this.maxAge,
    this.description,
    this.category,
    this.type = EventType.public,
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
    int? minAge,
    int? maxAge,
    String? description,
    EventCategory? category,
    EventType? type,
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
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }
}
