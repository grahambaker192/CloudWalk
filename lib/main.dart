import 'package:cloudwalk/trial_feedback.dart';
import 'package:flutter/material.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcomePage.dart';
import 'getStarted.dart';
import 'graphs.dart';
import 'exersises.dart';



void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WelcomeTransition()
            //WelcomeTransition()
    );
  }
}
