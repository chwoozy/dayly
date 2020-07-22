import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'select_time_screen.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:dayly/components/loading.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/models/task_data.dart';

class SelectSchedulableScreen extends StatefulWidget {
  final List<Schedulable> listForScheduling;

  SelectSchedulableScreen(this.listForScheduling);

  @override
  _SelectSchedulableScreenState createState() =>
      _SelectSchedulableScreenState();
}

class _SelectSchedulableScreenState extends State<SelectSchedulableScreen> {
  List<Schedulable> _selectedTask = [];
  //List<Schedulable> _listForScheduling = [];
  bool _loadingInProgress = true;
  int _totalDuration = 0;
  String productivityLevel = 'High';
  List<String> productivity = <String>[
    'High',
    'Medium',
    'Low',
  ];

  int getTotalDuration(List<Schedulable> selectedTasks) {
    int result = 0;
    for (int i = 0; i < selectedTasks.length; i++) {
      if (selectedTasks != null &&
          selectedTasks[i].toBeScheduled &&
          selectedTasks[i].duration != null) {
        result += selectedTasks[i].duration;
      }
    }
    return result;
  }

  List<Schedulable> getSelectedTasks(List<Schedulable> selectedTasks) {
    List<Schedulable> _selectedTask = [];
    for (int i = 0; i < selectedTasks.length; i++) {
      if (selectedTasks != null && selectedTasks[i].toBeScheduled) {
        _selectedTask.add(selectedTasks[i]);
      }
    }
    return _selectedTask;
  }

  String getDuration(int duration) {
    if (duration != null) {
      String hours = (duration / 60).toStringAsFixed(1);
      return hours + ' h';
    } else {
      return ' None ';
    }
  }

  void _getTaskData() async {
    User user = Provider.of<User>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user.uid);
    TaskData taskData = Provider.of<TaskData>(context, listen: false);
    await databaseService.getTasks(taskData);
    setState(() {
      _loadingInProgress = false;
    });
  }

  //Obtain task data from Firebase
  @override
  void initState() {
    super.initState();
    _getTaskData();
  }

  @override
  Widget build(BuildContext context) {
//    TaskData tasks = Provider.of<TaskData>(context, listen: true);
//    _listForScheduling = tasks.toSchedule();
    return _loadingInProgress
        ? Loading()
        : Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
              ),
              height: MediaQuery.of(context).size.height * .80,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Select Task For Scheduling',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.orange,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'How Do You feel Today?',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Spacer(),
                        RaisedButton(
                          color: Color(0xFF3A3E88),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.all(12),
                          textColor: Colors.white,
                          child: Text('Pick Productivity Level'),
                          onPressed: () {
                            showMaterialScrollPicker(
                              maxLongSide: 280,
                              maxShortSide: 250,
                              context: context,
                              title: "Pick Productivity Level",
                              items: productivity,
                              selectedItem: productivityLevel,
                              onChanged: (value) =>
                                  setState(() => productivityLevel = value),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Select Your Task',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: this.widget.listForScheduling.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemBuilder: (context, index) {
                          final schedulable =
                              this.widget.listForScheduling[index];
                          return Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return ListTile(
                                  title: Text(
                                    schedulable.name,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Duration: ' +
                                        getDuration(schedulable.duration),
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    value: schedulable.toBeScheduled,
                                    onChanged: (checkboxState) {
                                      setState(() {
                                        schedulable.toggleScheduling();
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Color(0xFF3A3E88),
                      label: Text('Next'),
                      onPressed: () async {
                        for (Schedulable i in this.widget.listForScheduling) {
                          if (productivityLevel == 'High') {
                            i.changeDuration(0.8);
                          } else if (productivityLevel == 'Medium') {
                            continue;
                          } else {
                            i.changeDuration(1.2);
                          }
                        }
                        _totalDuration =
                            getTotalDuration(this.widget.listForScheduling);
                        _selectedTask =
                            getSelectedTasks(this.widget.listForScheduling);
                        //print(_totalDuration);
                        Navigator.pop(context);
                        await showBarModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(22),
                              topLeft: Radius.circular(22),
                            ),
                          ),
                          builder: (context, scrollController) =>
                              SelectTimeScreen(
                            duration: _totalDuration,
                            listForScheduling: _selectedTask,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
