import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'const.dart';

class ExersizesPage extends StatefulWidget {
  final int index;
  const ExersizesPage(this.index, {Key? key}) : super(key: key);

  @override
  State<ExersizesPage> createState() => _ExersizesPageState();
}

class _ExersizesPageState extends State<ExersizesPage> {
  @override
  void initState() {
    List<int> tempList = getExercisesList(predictions[widget.index]);
    for(int i =0;i<tempList.length;i++){
      exercises.add(getExerciseContainer(tempList[i]));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tanColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Flexible(
        child: CardSwiper(
          cardsCount: exercises.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) =>
              exercises[index],
        ),
      ),
    );
  }
}

List<Container> exercises = [


];

Container getExerciseContainer(int index) {

  return Container(
    decoration: BoxDecoration(
      color: getExerciseString(index,"type")=="Ex"?blueShade:(getExerciseString(index,"type")=="Wo"?darkBlue:cloudColor),
      borderRadius: BorderRadius.circular(10)
    ),
    alignment: Alignment.center,
    child: Positioned.fill(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(getExerciseString(index,"gifFilePath")),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: blueShade,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        getExerciseString(index, "name"),
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: SingleChildScrollView(
                        child: Text(
                          getExerciseString(index, "description"),
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: darkBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: blueShade,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "How it helps",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text(
                        getExerciseString(index, "helpfulInfo"),
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

