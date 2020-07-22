//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:dayly/models/schedulable.dart';
//
//class selectSchedulable extends StatelessWidget {
//
//  List<Schedulable> listForScheduling;
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      decoration: BoxDecoration(
//        borderRadius: BorderRadius.circular(22),
//      ),
//      height: MediaQuery.of(context).size.height * .50,
//      child: Padding(
//        padding: EdgeInsets.all(16),
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Text(
//                  'Select Task For Scheduling',
//                  style: GoogleFonts.lato(
//                    textStyle: TextStyle(
//                      color: Colors.black,
//                      fontSize: 20,
//                      fontWeight: FontWeight.w600,
//                    ),
//                  ),
//                ),
//                Spacer(),
//                IconButton(
//                  icon: Icon(
//                    Icons.cancel,
//                    color: Colors.orange,
//                    size: 35,
//                  ),
//                  onPressed: () {
//                    Navigator.pop(context);
//                  },
//                )
//              ],
//            ),
//            ListView.separated(
//              padding: EdgeInsets.symmetric(vertical: 10),
//              scrollDirection: Axis.vertical,
//              shrinkWrap: true,
//              itemCount: listForScheduling.length,
//              separatorBuilder: (BuildContext context, int index) =>
//                  Divider(),
//              itemBuilder: (context, index) {
//                final schedulable = listForScheduling[index];
//                return Container(
//                  padding: EdgeInsets.only(left: 10),
//                  decoration: BoxDecoration(
//                    border:
//                    Border.all(style: BorderStyle.solid, width: 1),
//                    borderRadius: BorderRadius.circular(10),
//                    color: Colors.white,
//                  ),
//                  child: StatefulBuilder(
//                    builder:
//                        (BuildContext context, StateSetter setState) {
//                      return ListTile(
//                        title: Text(
//                          schedulable.name,
//                          style: GoogleFonts.lato(
//                            textStyle: TextStyle(
//                              color: Colors.black,
//                              fontSize: 20,
//                              fontWeight: FontWeight.w500,
//                            ),
//                          ),
//                        ),
//                        subtitle: Text(
//                          'Duration: ' +
//                              getDuration(schedulable.duration),
//                          style: GoogleFonts.lato(
//                            textStyle: TextStyle(
//                              color: Colors.black,
//                              fontSize: 15,
//                              fontWeight: FontWeight.w500,
//                            ),
//                          ),
//                        ),
//                        trailing: Checkbox(
//                          value: schedulable.toBeScheduled,
//                          onChanged: (checkboxState) {
//                            setState(() {
//                              schedulable.toggleScheduling();
//                            });
//                          },
//                        ),
//                      );
//                    },
//                  ),
//                );
//              },
//            ),
//            SizedBox(
//              height: MediaQuery.of(context).size.height * .03,
//            ),
//            RaisedButton(
//              color: Colors.lightBlue,
//              shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(18),
//              ),
//              padding: EdgeInsets.all(12),
//              textColor: Colors.white,
//              child: Text('Next'),
//              onPressed: () {
////                      Navigator.pop(context);
//              },
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
