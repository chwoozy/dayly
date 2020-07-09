import 'package:dayly/components/loading.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// class MonthView extends StatefulWidget {
//   final User user;
//   final DateTime selectedDate;

//   const MonthView({Key key, this.user, this.selectedDate});
//   @override
//   _MonthViewState createState() => _MonthViewState();
// }

// class _MonthViewState extends State<MonthView> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Event>>(
//         future: DatabaseService(uid: widget.user.uid).allEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return SfCalendar(
//                 view: CalendarView.month,
//                 initialDisplayDate: widget.selectedDate,
//                 dataSource: EventDataSource(snapshot.data),
//                 onTap: (CalendarTapDetails details) {
//                   Navigator.pop(context, details.date);
//                 });
//           } else {
//             return Loading();
//           }
//         });
//   }
// }

class MonthView extends StatelessWidget {
  final User user;
  final DateTime selectedDate;

  const MonthView({Key key, this.user, this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
        future: DatabaseService(uid: user.uid).allEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCalendar(
                view: CalendarView.month,
                initialDisplayDate: selectedDate,
                dataSource: EventDataSource(snapshot.data),
                onTap: (CalendarTapDetails details) {
                  Navigator.pop(context, details.date);
                });
          } else {
            return Loading();
          }
        });
  }
}
