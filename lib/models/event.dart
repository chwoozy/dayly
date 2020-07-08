import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';

class Event {
  static var _uuid = Uuid();
  final String eid;
  final String title;
  final String description;
  final DateTime eventFromDate;
  final DateTime eventToDate;
  final Color eventColor;
  final bool isAllDay;

  Event({
    this.eid,
    this.title,
    this.description,
    this.eventFromDate,
    this.eventToDate,
    this.eventColor,
  }) : this.isAllDay = false;
  // }) : this.isAllDay = eventFromDate.compareTo(eventToDate) != 0 ? false : true;

  Event.newEvent(this.title, this.description, this.eventFromDate,
      this.eventToDate, this.eventColor)
      : this.eid = _uuid.v4(),
        this.isAllDay = false;
  // eventFromDate.compareTo(eventToDate) != 0 ? false : true;
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments[index].title;
  }

  String getDescription(int index) {
    return appointments[index].description;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].eventFromDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].eventToDate;
  }

  @override
  Color getColor(int index) {
    return appointments[index].eventColor;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
