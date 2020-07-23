import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/components/menu_button.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/Schedule/schedule_screen.dart';
import 'package:dayly/pages/Schedule/toschedule.dart';
import 'package:dayly/pages/calendar/calendar.dart';
import 'package:dayly/pages/leaderboard/leaderboard.dart';
import 'package:dayly/pages/profile/profile.dart';
import 'package:dayly/pages/todo_list/todo.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  Offset _offset = Offset(0, 0);
  GlobalKey _globalKey = GlobalKey();
  List<double> limits = [];
  bool isSidebarOpen = false;
  final List<Widget> _children = [
    Calendar(),
    ToDo(),
    ToSchedule(),
    Leaderboard(),
    Profile(),
  ];

  @override
  void initState() {
    limits = [0, 0, 0, 0, 0, 0];
    super.initState();
  }

  getPosition(duration) {
    RenderBox renderBox = _globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy;
    double containerLimit = position.dy + renderBox.size.height;
    double next = (containerLimit - start) / 8;
    List<double> newlimit = [];
    for (double x = start; x <= containerLimit; x = x + next) {
      newlimit.add(x);
    }
    setState(() {
      limits = newlimit;
    });
  }

  Color getColor(int x) {
    Color color = (_offset.dy > limits[x] && _offset.dy < limits[x + 1])
        ? Colors.yellowAccent
        : Colors.grey[350];
    return color;
  }

  Stream<UserData> getUserData() {
    final user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    return database.userData;
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    double sidebarSize = mediaQuery.width * 0.65;
    double menuHeight = mediaQuery.height / 2;

    return StreamBuilder<UserData>(
        stream: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback(getPosition);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                  width: mediaQuery.width,
                  child: Stack(children: <Widget>[
                    GestureDetector(
                      child: AbsorbPointer(
                          absorbing: isSidebarOpen,
                          child: _children[_currentIndex]),
                      onTap: () {
                        if (isSidebarOpen) {
                          setState(() {
                            isSidebarOpen = false;
                          });
                        }
                      },
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 1500),
                      left: isSidebarOpen ? 0 : -sidebarSize + 10,
                      top: 0,
                      curve: Curves.elasticOut,
                      child: SizedBox(
                        width: sidebarSize,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (details.localPosition.dx <= sidebarSize) {
                              setState(() {
                                _offset = details.localPosition;
                              });
                            }

                            if (details.localPosition.dx > sidebarSize - 10 &&
                                details.delta.distanceSquared > 2) {
                              setState(() {
                                isSidebarOpen = true;
                              });
                            }
                          },
                          onPanEnd: (details) {
                            setState(() {
                              _offset = Offset(0, 0);
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              CustomPaint(
                                size: Size(sidebarSize, mediaQuery.height),
                                painter: DrawerPainter(offset: _offset),
                              ),
                              Container(
                                  height: mediaQuery.height,
                                  width: sidebarSize,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Container(
                                          height: mediaQuery.height * 0.25,
                                          child: Center(
                                            child: Column(children: <Widget>[
                                              Container(
                                                height:
                                                    mediaQuery.height * 0.15,
                                                width: mediaQuery.height * 0.15,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        snapshot.data.photoUrl),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 3.0),
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      mediaQuery.height * 0.03),
                                              Text(snapshot.data.displayName,
                                                  style: TextStyle(
                                                      fontSize: 20.0)),
                                            ]),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 4,
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    mediaQuery.width * 0.03),
                                            key: _globalKey,
                                            width: double.infinity,
                                            height: menuHeight,
                                            child: Column(
                                              children: <Widget>[
                                                MenuButton(
                                                  text: "Calendar",
                                                  iconData:
                                                      FontAwesomeIcons.calendar,
                                                  iconColor: Colors.red,
                                                  textSize: 20,
                                                  height: menuHeight / 8,
                                                  color: getColor(0),
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentIndex = 0;
                                                      isSidebarOpen = false;
                                                    });
                                                  },
                                                ),
                                                MenuButton(
                                                  text: "Tasks",
                                                  iconData: Icons.assignment,
                                                  iconColor: Colors.blue,
                                                  textSize: 20,
                                                  height: menuHeight / 8,
                                                  color: getColor(1),
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentIndex = 1;
                                                      isSidebarOpen = false;
                                                    });
                                                  },
                                                ),
                                                MenuButton(
                                                  text: "Schedules",
                                                  iconData: Icons
                                                      .format_list_bulleted,
                                                  iconColor: Colors.green,
                                                  textSize: 20,
                                                  height: menuHeight / 8,
                                                  color: getColor(2),
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentIndex = 2;
                                                      isSidebarOpen = false;
                                                    });
                                                  },
                                                ),
                                                MenuButton(
                                                  text: "Leaderboards",
                                                  iconData: Icons.equalizer,
                                                  iconColor: Colors.yellow,
                                                  textSize: 20,
                                                  height: menuHeight / 8,
                                                  color: getColor(3),
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentIndex = 3;
                                                      isSidebarOpen = false;
                                                    });
                                                  },
                                                ),
                                                MenuButton(
                                                  text: "Profile",
                                                  iconData: Icons.perm_identity,
                                                  iconColor: Colors.grey,
                                                  textSize: 20,
                                                  height: menuHeight / 8,
                                                  color: getColor(4),
                                                  onPressed: () {
                                                    setState(() {
                                                      _currentIndex = 4;
                                                      isSidebarOpen = false;
                                                    });
                                                  },
                                                ),
                                              ],
                                            )),
                                      ]))
                            ],
                          ),
                        ),
                      ),
                    )
                  ])),
              // bottomNavigationBar: CurvedNavigationBar(
              //   height: 55,
              //   index: _currentIndex,
              //   backgroundColor: Theme.of(context).canvasColor,
              //   color: Theme.of(context).canvasColor,
              //   items: <Widget>[
              //     Icon(Icons.event, size: 30, color: Colors.tealAccent[400]),
              //     Icon(Icons.assignment, size: 30, color: Colors.tealAccent[400]),
              //     Icon(Icons.equalizer, size: 30, color: Colors.tealAccent[400]),
              //     Icon(
              //       Icons.format_list_bulleted,
              //       size: 30,
              //       color: Colors.tealAccent[400],
              //     ),
              //     Icon(Icons.perm_identity, size: 30, color: Colors.tealAccent[400]),
              //   ],
              //   animationDuration: Duration(
              //     milliseconds: 200,
              //   ),
              //   onTap: (index) {
              //     //Handle button tap
              //     setState(() => _currentIndex = index);
              //   },
              // )
            );
          } else {
            return Loading();
          }
        });
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[900]
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
