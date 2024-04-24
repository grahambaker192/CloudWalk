import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'const.dart';

class CubePosition {
  double x;
  double y;
  double z;

  CubePosition({required this.x, required this.y, required this.z});
}

class ScatterPlot3d extends StatefulWidget {
  final int index;
  ScatterPlot3d({Key? key, required this.index}) : super(key: key);


  @override
  _ScaterPlot3dState createState() => _ScaterPlot3dState();
}

class _ScaterPlot3dState extends State<ScatterPlot3d>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  double _currentSliderValue = 1;
  List<CubePosition> _cubePositions = [];
  List<Object> _cubes = [];
  late AnimationController _controller;
  late Timer _timer;
  int _sliderMaxValue = 0;
  bool _isTimerPaused = false;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 20;
    _createCubes();
  }

  void _addCube(double x, double y, double z) {
    _cubePositions.add(CubePosition(x: x, y: y, z: z));
  }

  void _createCubes() {
    _cubes.clear();
    _cubePositions.forEach((position) {
      final updatedCube = Object(
        scale: Vector3(0.1, 0.1, 0.1),
        backfaceCulling: false,
        fileName: 'assets/cube.obj',
        position: Vector3(position.x, position.y, position.z),
      );
      _cubes.add(updatedCube);
    });

    _scene.world.children.clear();

    _cubes.forEach((cube) {
      _scene.world.add(cube);
    });

    _scene.update();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 30000),
      vsync: this,
    )..addListener(() {
      _cubePositions.forEach((position) {
        position.x += 0.1;
        position.y += 0.1;
        position.z += 0.1;
      });
      _updateCubePositions();
    })..repeat();
    _sliderMaxValue = AnalyzedArrays[widget.index].length;
    _timer = Timer.periodic(Duration(milliseconds: 150), (_) {
      if (!_isTimerPaused) {
        setState(() {
          _currentSliderValue++;
          if (_currentSliderValue > _sliderMaxValue) {
            _currentSliderValue = 1; // Reset to the beginning
          }
          _updateCubes();
        });
      }
    });
  }
  void _updateCubes() {
    _cubes.clear();
    _cubePositions.clear();
    int sliderIndex = _currentSliderValue.toInt();
    if (sliderIndex >= 0 && sliderIndex < AnalyzedArrays[widget.index].length) {
      for (int i = 0; i < AnalyzedArrays[widget.index][sliderIndex].length; i++) {
        _addCube(
          AnalyzedArrays[widget.index][sliderIndex][i][0],
          AnalyzedArrays[widget.index][sliderIndex][i][1],
          AnalyzedArrays[widget.index][sliderIndex][i][2],
        );
      }
      _createCubes();
    }
  }
  void _updateCubePositions() {
    for (int i = 0; i < _cubes.length && i < _cubePositions.length; i++) {
      final cube = _cubes[i];
      final position = _cubePositions[i];
      cube.position.setValues(position.x, position.y, position.z);
    }
    _scene.update();
  }
  void _toggleTimer() {
    setState(() {
      _isTimerPaused = !_isTimerPaused;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tanColor,
      appBar: AppBar(
        backgroundColor: tanColor,
        title: Text("${TrialNameList[widget.index]} Model"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: Cube(
                onSceneCreated: _onSceneCreated,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _toggleTimer,
                  icon: Icon(
                    _isTimerPaused ? Icons.play_arrow : Icons.pause,
                    size: 36,
                  ),
                ),
                Slider(
                  inactiveColor: darkBlue,
                  activeColor: darkBlue,
                  value: _currentSliderValue,
                  max: _sliderMaxValue.toDouble(),
                  divisions: _sliderMaxValue - 1,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                      _updateCubes();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
