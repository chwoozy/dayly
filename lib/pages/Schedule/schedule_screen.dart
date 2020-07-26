import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dayly/models/schedulable.dart';
import 'package:dayly/pages/Schedule/select_schedulable_screen.dart';
import 'package:dayly/services/database.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/components/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:dayly/components/schedulable_tile.dart';
import 'package:dayly/models/quote.dart';
import 'package:http/http.dart' as http;

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Schedulable> _finalResult = [];
  List<Schedulable> _listForScheduling = [];
  bool _loadingInProgress = true;
  Quote _quote;
  String greeting = '';

  Future<Quote> fetchQuote() async {
    final response = await http.get('https://favqs.com/api/qotd');
    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Quote');
    }
  }

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
    _quote = await fetchQuote();
    for (Schedulable item in taskData.schedules) {
      _finalResult.add(item);
    }
    _finalResult.sort((a, b) => a.dateTime.compareTo(b.dateTime));
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
                  //backgroundColor: Color(0xFF3A3E88),
                  onPressed: () {
                    _taskEditModalBottomSheet(context, _listForScheduling);
                  },
                  label: Text("Create Schedule"),
                ),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.1,
                  title: Text('Schedules'),
                ),
                body: Stack(
                  children: <Widget>[
//                    Container(
//                      height: MediaQuery.of(context).size.height * 0.2,
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                          color: Colors.tealAccent[400],
//                          borderRadius: BorderRadius.only(
//                              bottomLeft: Radius.circular(20),
//                              bottomRight: Radius.circular(20))),
//                    ),
                    SafeArea(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.format_quote),
                                SizedBox(width: 10),
                                Text(
                                  'Quote Of The Day',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            //height: MediaQuery.of(context).size.height * 0.2,
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.2,
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
//                                image: DecorationImage(
//                                  image: AssetImage('assets/images/quotes.jpg'),
//                                  fit: BoxFit.cover,
//                                ),
                                //color: Colors.tealAccent[400],
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: Colors.white)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  ' " ' + _quote.quoteText + ' " ',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '-' + _quote.quoteAuthor,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.format_list_bulleted),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Your Schedule',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                                scrollDirection: Axis.vertical,
                                children: List.generate(
                                    this._finalResult.length, (index) {
                                  return SchedulableTile(
                                      schedule: this._finalResult[index],
                                      key: ValueKey(index));
                                })),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
  }
}
