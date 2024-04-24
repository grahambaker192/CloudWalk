import 'package:flutter/material.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exersises.dart';
import 'graphs.dart';
import 'progress.dart';
import 'welcomePage.dart';

class FeedbackPage extends StatefulWidget {
  final int index;

  const FeedbackPage(this.index, {Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: tanColor,
      body: CorrectForm.length - 1 >= widget.index &&
          TrialNameList.length - 1 >= widget.index &&
          AnalyzedArrays.length - 1 >= widget.index
          ? (AnalyzedArrays[widget.index] == badDataList
          ? Center(
        child: Positioned.fill(
          child: Container(
            child: Text(
              "Video is not clear enough",
              style: TextStyle(fontSize: 20, color: tanColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      )
          : Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              color: cloudColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExersizesPage(widget.index),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Exercises",
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 30,
                                    color: darkBlue,
                                  ),
                                ),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                              color: tanColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.05)),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              color: cloudColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Graphs(widget.index),
                                  ),
                                );
                              },
                              child: Container(
                                child: Center(
                                  child: Text(
                                    "Graphs",
                                    style: GoogleFonts.robotoCondensed(
                                      fontSize: 30,
                                      color: darkBlue,
                                    ),
                                  ),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 6,
                                decoration: BoxDecoration(
                                  color: tanColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    title: Text(
                      "${TrialNameList[widget.index]}",
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 30, fontWeight: FontWeight.bold, color: darkBlue),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                child: Icon(
                  CorrectForm[widget.index] ? Icons.check_circle_sharp : Icons.block_sharp,
                  color: CorrectForm[widget.index] ? Colors.green : Colors.red,
                  size: 230.0,
                ),
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tanColor,
                ),
              ),
            ),
          ),
        ],
      ))
          : Center(
        child: Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Icon(Icons.fmd_bad_outlined, size: 42, color: Colors.red)),
                Text(
                  "Processing",
                  style: TextStyle(fontSize: 30, color: darkBlue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
