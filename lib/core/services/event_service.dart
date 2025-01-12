import '../models/event.dart';
import '../models/response.dart';

abstract class EventService {
  Future<Event> createEvent(Event event);
  Future<Event> getEvent(String eventId);
  Future<List<Event>> getUserEvents(String userId);
  Future<void> updateEvent(Event event);
  Future<void> deleteEvent(String eventId);

  Future<EventResponse> respondToEvent(EventResponse response);
  Future<List<EventResponse>> getEventResponses(String eventId);
  Future<EventResponse?> getUserEventResponse(String eventId, String userId);

  Stream<Event> eventStream(String eventId);
  Stream<List<Event>> userEventsStream(String userId);
}
