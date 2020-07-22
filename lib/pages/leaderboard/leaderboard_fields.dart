import 'package:dayly/models/score.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeaderboardFields extends StatelessWidget {
  final int index;
  final List<Score> scores;

  LeaderboardFields({this.index, this.scores});

  @override
  Widget build(BuildContext context) {
    Widget badge;
    Color gold = Color(0xFFFFDD50);
    Color silver = Color(0xFFD9DACA);
    Color bronze = Color(0xFFF4AA6B);
    Color others = Color(0xFFF9F9F9);
    int i = index + 1;

    badge = Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: Colors.white),
            color: Colors.white),
        child: i == 1
            ? Padding(
                padding: const EdgeInsets.all(3.0),
                child:
                    SvgPicture.asset('assets/images/gold-cup.svg', height: 18),
              )
            : i == 2
                ? Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SvgPicture.asset('assets/images/silver-cup.svg',
                        height: 18),
                  )
                : i == 3
                    ? Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: SvgPicture.asset('assets/images/bronze-cup.svg',
                            height: 18),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 10,
                        child: Text(
                          index.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9),
                        )));

    return FutureBuilder(
        future: DatabaseService(uid: scores[index].uid).fetchUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: i == 1
                        ? gold
                        : i == 2 ? silver : i == 3 ? bronze : others,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5.0)
                    ]),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data.photoUrl)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    )),
                              ),
                              Positioned(top: -15, left: -12, child: badge),
                            ],
                          ),
                          Text(
                            scores[index].name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: SvgPicture.asset(
                              'assets/images/diamond.svg',
                              height: 25,
                            ),
                          ),
                          Text(
                            scores[index].score.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: others,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5.0)
                      ]),
                  child: Center(child: CircularProgressIndicator())),
            );
          }
        });
  }
}
