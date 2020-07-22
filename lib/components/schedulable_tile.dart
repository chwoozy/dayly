import 'package:flutter/material.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class SchedulableTile extends StatelessWidget {
  final Schedulable schedule;
  final key;

  SchedulableTile({
    this.schedule,
    this.key,
  });

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
          child: this.schedule.category == 'Event'
              ? Text(
                  this.schedule.dateTime == null
                      ? 'None'
                      : '${this.schedule.dateTime.hour.toString().padLeft(2, '0')} : ${this.schedule.dateTime.minute.toString().padLeft(2, '0')}',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w800,
                  ),
                )
              : Text(
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
                'Duration(With Break): ' +
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
