import 'package:flutter/material.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/todo_list/select_schedulable_screen.dart';
import 'package:dayly/services/database.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dayly/components/schedulable_tile.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Schedulable> _finalResult = [];
  List<Schedulable> _listForScheduling = [];
  bool _loadingInProgress = true;

  void _taskEditModalBottomSheet(
      BuildContext context, List<Schedulable> listForScheduling) {
    showBarModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(22),
          topLeft: Radius.circular(22),
        ),
      ),
      builder: (context, scrollController) =>
          SelectSchedulableScreen(listForScheduling),
    );
  }

  void _getTaskData() async {
    User user = Provider.of<User>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user.uid);
    TaskData taskData = Provider.of<TaskData>(context, listen: false);
    await databaseService.getTasks(taskData);
    await databaseService.getSchedule(taskData);
    _finalResult = taskData.schedules;
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
    TaskData tasks = Provider.of<TaskData>(context, listen: true);
    _listForScheduling = tasks.toSchedule();
    return _loadingInProgress
        ? Loading()
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Color(0xFF3A3E88),
                  onPressed: () {
                    _taskEditModalBottomSheet(context, _listForScheduling);
                  },
                  label: Text("Create Schedule"),
                ),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.1,
                  //backgroundColor: Color.fromRGBO(64, 75, 96, .9),
                  backgroundColor: Color(0xFF3A3E88),
                  title: Text('Schedules'),
                ),
                body: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bkg.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                              scrollDirection: Axis.vertical,
                              children: List.generate(this._finalResult.length,
                                  (index) {
                                return SchedulableTile(
                                    schedule: this._finalResult[index],
                                    key: ValueKey(index));
                              })),
                        ),
                      ],
                    ),
                  ],
                )),
          );
  }
}
