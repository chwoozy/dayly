import 'package:dayly/components/constants.dart';
import 'package:dayly/components/loading.dart';
import 'package:dayly/models/score.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/pages/leaderboard/leaderboard_fields.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);

    return FutureBuilder(
      future: DatabaseService(uid: _user.uid).getScore,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Score> scores = snapshot.data;
          scores.sort();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Leaderboards',
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
                IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.ellipsisV,
                    size: 20,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          "${DateTime.now().day} ${DateFormat('MMMM').format(DateTime.now())}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Today',
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15)),
                    ],
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LeaderboardFields(index: index, scores: scores);
                  },
                )),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
