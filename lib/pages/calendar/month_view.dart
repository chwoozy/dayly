import 'package:dayly/components/loading.dart';
import 'package:dayly/models/event.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
                cellBorderColor: Color(0xFF303030),
                todayHighlightColor: Colors.indigoAccent,
                headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontFamily: 'Falling',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center),
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle,
                ),
                monthViewSettings: MonthViewSettings(
                    dayFormat: 'EEE',
                    monthCellStyle: MonthCellStyle(
                      textStyle: TextStyle(
                        fontFamily: 'Falling',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      trailingDatesTextStyle: TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontFamily: 'Falling',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      leadingDatesTextStyle: TextStyle(
                        color: Color(0xFF5E5E5E),
                        fontFamily: 'Falling',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
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
