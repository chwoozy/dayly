import 'package:uuid/uuid.dart';

class Event {
  static var _uuid = Uuid();
  final String eid;
  final String title;
  final String description;
  final DateTime eventFromDate;
  final DateTime eventToDate;

  Event(
      {this.eid,
      this.title,
      this.description,
      this.eventFromDate,
      this.eventToDate});

  Event.newEvent(
      this.title, this.description, this.eventFromDate, this.eventToDate)
      : this.eid = _uuid.v4();

  // factory Event.fromMap(Map data) {
  //   return Event(
  //     title: data['title'],
  //     description: data['description'],
  //     eventDate: data['event_date'],
  //   );
  // }

  // factory Event.fromDS(String id, Map<String, dynamic> data) {
  //   return Event(
  //     id: id,
  //     title: data['title'],
  //     description: data['description'],
  //     eventDate: data['event_date'].toDate(),
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     "title": title,
  //     "description": description,
  //     "event_date": eventDate,
  //     "uid": id,
  //   };
  // }
}
