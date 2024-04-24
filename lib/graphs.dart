import 'package:cloudwalk/scatterPlot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'scatterPlot.dart';

class Graphs extends StatefulWidget {
  final int index;
  const Graphs(this.index, {Key? key}) : super(key: key);

  @override
  State<Graphs> createState() => _GraphsState();
}


@override

class _GraphsState extends State<Graphs> {
  final List<List<List<List<double>>>> _posibleGraphs = List.from(AnalyzedArrays);
  final List<String> _tempTrialNameList = List.from(TrialNameList);
  int _selectedGraphIdexOne = 0;
  int _selectedGraphIdexTwo = 0;
  int selectedBodyPointIndex = 0;
  int selectedMeasurementIndex = 0;
  void initState() {
    _posibleGraphs.add(proArraySprint);
    _posibleGraphs.add(proArrayLong);
    _tempTrialNameList.add("Sprint Example");
    _tempTrialNameList.add("Long Distance");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("${TrialNameList[widget.index]} Graphs"),
      ),
      backgroundColor: tanColor,
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.transparent,
                child: DropdownButton<int>(
                  value: selectedBodyPointIndex,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: darkBlue, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: cloudColor,
                  ),
                  onChanged: (int? index) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedBodyPointIndex = index!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    BodyPoints.length,
                    (index) {
                      final bodyPoint = BodyPoints[
                          index]; // Access the string value using the index
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(bodyPoint), // Display the string value
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                child: DropdownButton<int>(
                  value: selectedMeasurementIndex,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: darkBlue, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: cloudColor,
                  ),
                  onChanged: (int? index) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedMeasurementIndex = index!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    Measurements.length,
                    (index) {
                      final measurement = Measurements[
                          index]; // Access the string value using the index
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(measurement), // Display the string value
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.transparent,
                child: DropdownButton<int>(
                  value: _selectedGraphIdexOne,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: darkBlue, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: Colors.green,
                  ),
                  onChanged: (int? index) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedGraphIdexOne = index!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    _tempTrialNameList.length,
                        (index) {
                        final String displayedName = _tempTrialNameList[index].length > 6
                            ? _tempTrialNameList[index].substring(0, 7)
                            : _tempTrialNameList[index];
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(displayedName), // Display the string value
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                child: DropdownButton<int>(
                  value: _selectedGraphIdexTwo,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: darkBlue, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: darkBlue,
                  ),
                  onChanged: (int? index) {
                    // This is called when the user selects an item.
                    setState(() {
                      _selectedGraphIdexTwo = index!;
                    });
                  },
                  items: List<DropdownMenuItem<int>>.generate(
                    _tempTrialNameList.length,
                        (index) {
                        final String displayedName = _tempTrialNameList[index].length > 6
                            ? _tempTrialNameList[index].substring(0, 7)
                            : _tempTrialNameList[index];
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(displayedName), // Display the string value
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8, // Example width
              height:
                  MediaQuery.of(context).size.height * 0.2, // Example height
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors
                      .black, // You can adjust the color of the border here
                  width: 2.0, // You can adjust the width of the border here
                ),
              ),
              child: Container(
                color: Colors.transparent,
                child: ScatterChartSample2(_posibleGraphs,_selectedGraphIdexOne, _selectedGraphIdexTwo,   widget.index, selectedBodyPointIndex,
                    selectedMeasurementIndex),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              child: Text(
                  'Data is relative to your center ("Spine One")'),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScatterPlot3d(index: widget.index)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Your Running Model',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

class ScatterChartSample2 extends StatefulWidget {
  final List<List<List<List<double>>>> _possibleGraphs;
  final int arrayIndex;
  final int bodyPoint;
  final int measurement;
  final int indexOne;
  final int indexTwo;
  const ScatterChartSample2(this. _possibleGraphs, this.indexOne,this.indexTwo, this.arrayIndex, this.bodyPoint, this.measurement,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScatterChartSample2State();
}

class _ScatterChartSample2State extends State<ScatterChartSample2> {
  int touchedIndex = -1;

  Color greyColor = Colors.grey;
  final _availableColors = [tanColor, darkBlue, cloudColor, Colors.black];

  PainterType _currentPaintType = PainterType.circle;

  static FlDotPainter _getPaint(PainterType type, double size, Color color) {
    return FlDotCirclePainter(
      color: color,
      radius: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    // (x, y, size)
    List<int> selectedSpots = [];
    final data = [];
    double? maxYValue = null;
    double? minYValue = null;

    final analyzedArrayOne = widget._possibleGraphs[widget.indexOne];
    final analyzedArrayTwo = widget._possibleGraphs[widget.indexTwo];
    bool _oneIsGreater = analyzedArrayOne.length>analyzedArrayTwo.length;

    for (var i = 0; i < analyzedArrayOne.length; i++) {
      var pointList = analyzedArrayOne[i];
      data.add(
          (_oneIsGreater?i.toDouble()/analyzedArrayOne.length*analyzedArrayTwo.length:i.toDouble(), pointList[widget.bodyPoint][widget.measurement], 4.0));
      if (maxYValue == null) {
        maxYValue = pointList[widget.bodyPoint][widget.measurement];
      } else if (maxYValue < pointList[widget.bodyPoint][widget.measurement]) {
        maxYValue = pointList[widget.bodyPoint][widget.measurement];
      }
      if (minYValue == null) {
        minYValue = pointList[widget.bodyPoint][widget.measurement];
      } else if (minYValue > pointList[widget.bodyPoint][widget.measurement]) {
        minYValue = pointList[widget.bodyPoint][widget.measurement];
      }
      selectedSpots.add(i);
    }


    for (var i = 0; i < analyzedArrayTwo.length; i++) {
      var pointList = analyzedArrayTwo[i];
      data.add(
          (_oneIsGreater?i.toDouble():i.toDouble()/analyzedArrayOne.length*analyzedArrayTwo.length, pointList[widget.bodyPoint][widget.measurement], 4.0));
      if (maxYValue == null) {
        maxYValue = pointList[widget.bodyPoint][widget.measurement];
      } else if (maxYValue < pointList[widget.bodyPoint][widget.measurement]) {
        maxYValue = pointList[widget.bodyPoint][widget.measurement];
      }
      if (minYValue == null) {
        minYValue = pointList[widget.bodyPoint][widget.measurement];
      } else if (minYValue > pointList[widget.bodyPoint][widget.measurement]) {
        minYValue = pointList[widget.bodyPoint][widget.measurement];
      }
    }

    minYValue = (minYValue ?? 0) - 0.5;
    maxYValue = (maxYValue ?? 0) + 0.5;

    return ScatterChart(
      ScatterChartData(
        scatterSpots: data.asMap().entries.map((e) {
          final index = e.key;
          final (double x, double y, double size) = e.value;
          return ScatterSpot(
            x,
            y,
            dotPainter: _getPaint(
              PainterType.circle,
              size,
              selectedSpots.contains(index)
                  ? Colors.green.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
            ),
          );
        }).toList(),
        minX: 0,
        maxX: (data.length).toDouble() / 2, //(data.length).toDouble()
        minY: minYValue, //minYValue
        maxY: maxYValue, //minYValue
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          checkToShowHorizontalLine: (value) => true,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Colors.transparent,
          ),
          drawVerticalLine: true,
          checkToShowVerticalLine: (value) => true,
          getDrawingVerticalLine: (value) => const FlLine(
            color: Colors.transparent,
          ),
        ),
        titlesData: const FlTitlesData(
          show: false,
        ),
        scatterTouchData: ScatterTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          mouseCursorResolver:
              (FlTouchEvent touchEvent, ScatterTouchResponse? response) {
            return response == null || response.touchedSpot == null
                ? MouseCursor.defer
                : SystemMouseCursors.click;
          },
          touchTooltipData: ScatterTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            getTooltipItems: (ScatterSpot touchedBarSpot) {
              return ScatterTooltipItem(
                'X: ',
                textStyle: TextStyle(
                  height: 1.2,
                  color: Colors.grey[100],
                  fontStyle: FontStyle.italic,
                ),
                bottomMargin: 10,
                children: [
                  TextSpan(
                    text: '${touchedBarSpot.x.toInt()} \n',
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'Y: ',
                    style: TextStyle(
                      height: 1.2,
                      color: Colors.grey[100],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: touchedBarSpot.y.toInt().toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
          touchCallback:
              (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
            if (touchResponse == null || touchResponse.touchedSpot == null) {
              return;
            }
            if (event is FlTapUpEvent) {
              final sectionIndex = touchResponse.touchedSpot!.spotIndex;
            }
          },
        ),
      ),
    );
  }
}

enum PainterType {
  circle,
  square,
  cross,
}
