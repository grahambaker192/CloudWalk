import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'const.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // Add this import for JSON decoding

import 'package:cloudwalk/const.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'welcomePage.dart';
import 'trial_feedback.dart';
import 'const.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;
  late String requestedVideoFilePath;
  late bool videoIsSent;
  late TextEditingController _textcontroller;
  late String _trialName;

  @override
  void initState() {
    super.initState();
    _textcontroller = TextEditingController();
    videoIsSent = false;
  }

  @override
  void dispose() {
    _textcontroller.dispose();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    setState(() {
      _currentSliderValue=0.0;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null && result.files.isNotEmpty) {
      File file = File(result.files.first.path!);
      requestedVideoFilePath = file.path; // Set the variable here
      _initializeController(file);
    }
  }

  void _initializeController(File file) async {
    VideoPlayerController controller = VideoPlayerController.file(file);

    await controller.initialize();

    setState(() {
      _controller?.dispose();
      _controller = controller;
    });

    if (_controller != null) {
      _controller!.addListener(() {
        setState(() {
          _currentSliderValue =
              _controller!.value.position.inMilliseconds.toDouble();
        });
      });
    }
  }

  void _sendVideo(String videoFilePath) async {
    try {
      print("_Sendvideo initiated");
      if (_controller != null) {
        // Prepare the request
        var uri = Uri.parse(
            '$flaskAddress/upload'); // Replace with your server's IP
        var request = http.MultipartRequest('POST', uri);
        // Attach the video file
        request.files.add(http.MultipartFile(
          'video',
          File(videoFilePath).readAsBytes().asStream(),
          File(videoFilePath).lengthSync(),
          filename: 'video.mp4',
          contentType: MediaType('video', 'mp4'),
        ));

        // Send the request
        http.Client().send(request).then((response) {
          if (response.statusCode == 200) {
            print('Video successfully sent to the server');
            // Parse the response body and save it as a variable
            sendRequest();
            response.stream.bytesToString().then((value) {

              // Update state here to trigger a rebuild
              if (_isPlaying) {
                _controller?.pause();
              }
              setState(() {
                videoIsSent = true;
                // Save the received array as a variable if needed
              });
            });
          } else {
            print('Failed to send video. Status Code: ${response.statusCode}');
          }
        });
      } else {
        print('No video selected');
      }
    } catch (e) {
      print('Error sending video: $e');
    }

    // Load thumbnail and add to myCardList
    final uint8list = await VideoThumbnail.thumbnailData(
      video: requestedVideoFilePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
    if (uint8list != null && uint8list.isNotEmpty) {
      setState(() {
        TrialNameList.add(_trialName);
        ThumbnailVideoPathList.add(uint8list);
      });
    }
  }

  void sendRequest() async {
    try {
      final response = await http.get(Uri.parse('$flaskAddress/analyze?value=1'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        List<dynamic> jsonArray = json.decode(response.body);

        // Ensure the response is a list of lists of lists of doubles
        if (jsonArray is List && jsonArray.isNotEmpty && jsonArray.every((elem) => elem is List)) {
          // Convert JSON lists to List<List<List<double>>>
          List<List<List<double>>> resultList = [];
          for (var sublist in jsonArray) {
            List<List<double>> doubleList = [];
            for (var subsublist in sublist) {
              List<double> innerDoubleList = [];
              for (var value in subsublist) {
                // Convert dynamic value to double
                innerDoubleList.add(double.parse(value.toString()));
              }
              doubleList.add(innerDoubleList);
            }
            resultList.add(doubleList);
          }

          // Print the entire list
          print(resultList);

          // Do whatever you need to do with the resultList, such as adding it to AnalyzedArrays
          AnalyzedArrays.add(resultList);
          sendMLResult();
        } else {
          print('Response does not contain a list of lists of lists of doubles');
        }
      } else if (response.statusCode == 300) {
        // Handle response status code 300
        AnalyzedArrays.add(badDataList);
        CorrectForm.add(false);
        predictions.add(0);
      }else if(response.statusCode == 500){
        AnalyzedArrays.add(badDataList);
        CorrectForm.add(false);
        predictions.add(0);
      }
    } catch (e) {
      AnalyzedArrays.add(badDataList);
      CorrectForm.add(false);
      predictions.add(0);
      print('Error: $e');
    }
  }

  Future<void> sendMLResult() async {
    try {
      final response = await http.get(Uri.parse('$flaskAddress/getmlresult?value=1'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('predicted_class_name') && responseBody.containsKey('impactful_joint')) {
          String predictedClassName = responseBody['predicted_class_name'];
          int impactfulJoint = responseBody['impactful_joint'];
          predictions.add(impactfulJoint);
          CorrectForm.add(predictedClassName == '"0"');

          print('Predicted Class Name: $predictedClassName');
          print('Impactful Joint: $impactfulJoint');

        } else {
          print('Unexpected response: $responseBody');
        }
      } else {
        print('Unexpected response status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: tanColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: videoIsSent
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Sent Sucsessfully!",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 70,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Results will show on the home page",
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            )
      : Center(
        child: Stack(
          children: [
            Center(
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _controller != null
                            ? AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: Stack(
                                children: [
                                  VideoPlayer(_controller!),
                                  Center(
                                    child: FloatingActionButton(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      foregroundColor: Colors.transparent,
                                      highlightElevation: 0.0,
                                      onPressed: () {
                                        setState(() {
                                          _isPlaying = !_isPlaying;
                                          if (_isPlaying) {
                                            _controller?.play();
                                          } else {
                                            _controller?.pause();
                                          }
                                        });
                                      },
                                      child: Icon(
                                        size: 70,
                                            () {
                                          if (_controller == null) {
                                            return null;
                                          } else if (_isPlaying) {
                                            return Icons.pause;
                                          } else {
                                            return Icons.play_arrow;
                                          }
                                        }(),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                            : GestureDetector(
                                onTap: () {
                                  _pickVideo();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.video_file_outlined,
                                    color: cloudColor,
                                    size: 70.0,
                                  ),
                                ),
                              ),
                        _controller != null
                            ? Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*2/3, // Set your desired width
                                  child: Slider(
                                    activeColor: cloudColor,
                                    inactiveColor: Colors.black,
                                    value: _currentSliderValue,
                                    onChanged: (value) {
                                      setState(() {
                                        _currentSliderValue = value;
                                        _controller!.seekTo(Duration(milliseconds: value.toInt()));
                                      });
                                    },
                                    min: 0.0,
                                    max: _controller!.value.duration.inMilliseconds.toDouble(),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {

                                            _pickVideo();

                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                            // Optional: Add padding if needed
                                            child: Icon(
                                              Icons.video_file_outlined,
                                              color:
                                                  cloudColor, // Set the desired color for the icon
                                              size: 50.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Alternate Video",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width:50),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Name your Trial'),
                                                  content: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      maxHeight:
                                                     75, // Set your maximum height here
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              _textcontroller,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Trial Name',
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _trialName = value;
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'Cancel'),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        if (requestedVideoFilePath != null) {
                                                          _sendVideo(
                                                              requestedVideoFilePath);
                                                          // Optionally, you can also pop the screen or perform other actions here
                                                          Navigator.pop(
                                                              context, 'OK');
                                                        } else {
                                                          print(
                                                              "No video selected");
                                                        }
                                                      },
                                                      child: Icon(Icons.analytics_outlined),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.send,
                                            color:
                                                cloudColor, // Set the desired color for the icon
                                            size: 40.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "Analyze",
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                            : Text(
                                "Upload Here",
                                style: TextStyle(fontSize: 20.0),
                              ),

                      ],
                    ),
            ),
            if (_controller == null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/2,

                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: SingleChildScrollView(
                      child: Text("Requirments",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("- Stable Camera",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("- Running path is parrelel to the camera",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("- Full body must be in frame the whole video",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("- Up to 3 or 4 seconds long",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
