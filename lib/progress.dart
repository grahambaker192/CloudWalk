import 'package:flutter/material.dart';
import 'const.dart';
class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:
      Center(child: Text("Progress Page")),
      color: tanColor,
    );
  }
}
