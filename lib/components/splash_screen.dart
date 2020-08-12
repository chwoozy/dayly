import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlareActor("assets/flare/moon.flr",
        alignment: Alignment.center,
        fit: BoxFit.cover,
        animation: "night_idle");
  }
}
