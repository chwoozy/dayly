import 'package:flutter/material.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SchedulableTile extends StatelessWidget {
  final Schedulable schedule;
  final key;

  SchedulableTile({this.schedule, this.key});

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineX: 0.3,
      topLineStyle: LineStyle(color: Colors.black.withOpacity(0.7)),
      indicatorStyle: IndicatorStyle(
        indicatorY: 0.3,
        drawGap: true,
        width: 35,
        height: 35,
        indicator: _IconIndicator(
          iconData:
              this.schedule.category == 'Task' ? Icons.schedule : Icons.event,
          size: 24,
        ),
      ),
      leftChild: Center(
        child: Container(
          alignment: Alignment(0.0, -0.50),
          child: Text(
            this.schedule.dateTime == null
                ? 'None'
                : '${this.schedule.dateTime.hour.toString().padLeft(2, '0')} : ${this.schedule.dateTime.minute.toString().padLeft(2, '0')}',
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      rightChild: Padding(
        padding: EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFDB84B1),
                Color(0xFF3A3E88),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.schedule.name,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Duration(With Buffer): ' +
                    this.schedule.getDuration(this.schedule.duration),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                this.schedule.description,
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
//    //return TimelineTile(
//      alignment: TimelineAlign.manual,
//      lineX: 0.2,
//      topLineStyle: LineStyle(color: Colors.black.withOpacity(0.7)),
//      rightChild: Card(
//        //key: ValueKey(this.schedule),
//        elevation: 2.0,
//        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//        child: Container(
//            decoration: BoxDecoration(
//              //color: Color.fromRGBO(64, 75, 96, .9),
//              borderRadius: BorderRadius.circular(16),
//            ),
//            child: ListTile(
//                contentPadding:
//                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
////              leading: Container(
////                width: 60,
////                padding: EdgeInsets.only(right: 12.0),
////                decoration: new BoxDecoration(
////                    border: new Border(
////                        right:
////                            new BorderSide(width: 1.0, color: Colors.white24))),
////                child: Icon(Icons.autorenew, color: Colors.white),
////              ),
//                title: Text(
//                  schedule.name,
//                  style: GoogleFonts.lato(
//                    textStyle: TextStyle(
//                      color: Colors.black,
//                      fontSize: 25,
//                      fontWeight: FontWeight.w800,
//                    ),
//                  ),
//                ),
//                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
//
//                subtitle: Row(
//                  children: <Widget>[
//                    //Icon(Icons.linear_scale, color: Colors.yellowAccent),
//                    Text(
//                      schedule.description,
//                      style: GoogleFonts.lato(
//                        textStyle: TextStyle(
//                          color: Colors.black,
//                          fontSize: 15,
//                          fontWeight: FontWeight.w800,
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//                trailing: Column(
//                  children: <Widget>[
//                    Icon(Icons.event_note, color: Colors.black, size: 30.0),
//                    Text(
//                        'Duration: ' + schedule.getDuration(schedule.duration)),
//                  ],
//                ))),
//      ),
//    );
  }
}

class _IconIndicator extends StatelessWidget {
  const _IconIndicator({
    Key key,
    this.iconData,
    this.size,
  }) : super(key: key);

  final IconData iconData;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.7), width: 2),
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                iconData,
                size: size,
                color: const Color(0xFF9E3773).withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
