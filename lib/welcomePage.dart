import 'package:flutter/material.dart';
import 'const.dart';
import 'dart:math' as math;
import 'progress.dart';
import 'upload.dart';
import 'trial_feedback.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 1;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: cloudColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart, size: 40.0),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 60.0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.run_circle_outlined, size: 40.0),
            label: 'Upload',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: tanColor,
        onTap: _onItemTapped,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getPage(_selectedIndex),
      ),
    );
  }
}

Widget _getPage(int index) {
  switch (index) {
    case 0:
      return FadeTransition(
        key: ValueKey<int>(index),
        opacity: AlwaysStoppedAnimation<double>(1.0),
        child: Progress(),
      );
    case 1:
      return FadeTransition(
        key: ValueKey<int>(index),
        opacity: AlwaysStoppedAnimation<double>(1.0),
        child: Welcome(),
      );
    case 2:
      return FadeTransition(
        key: ValueKey<int>(index),
        opacity: AlwaysStoppedAnimation<double>(1.0),
        child: Upload(),
      );
    default:
      return Container();
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}
final List<Widget> myCardList = [
  // Add more Card widgets as needed
];

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: tanColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Container(
                  color: tanColor,
                  height: MediaQuery.of(context).size.height*6.5/10,
                  child:

                  ListView.builder(
                    itemCount: ThumbnailVideoPathList.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = ThumbnailVideoPathList.length - 1 - index;
                      return GestureDetector(
                        onTap: () {
                          print("Reversed index is $reversedIndex");
                          Navigator.push(
                            context,

                            MaterialPageRoute(builder: (context) => FeedbackPage(reversedIndex)),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: Image.memory(ThumbnailVideoPathList[reversedIndex]),
                            title: Text(TrialNameList[reversedIndex]),
                          ),
                        ),
                      );
                    },
                  )
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height ,
                  child: Container(
                    color: tanColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4.5,
              decoration: BoxDecoration(
                color: cloudColor,
                boxShadow: [BoxShadow(blurRadius: 0.0)],
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    100.0,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width / 2,
                ),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  color: cloudColor,
                  boxShadow: [BoxShadow(blurRadius: 0)],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width / 3,
                      100.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: cloudColor,
                  boxShadow: [BoxShadow(blurRadius: 0)],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.height / 3,
                      100.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: MediaQuery.of(context).size.width / 10,
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: cloudColor,
                  boxShadow: [BoxShadow(blurRadius: 0)],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.height / 7,
                      100.0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 5 / 6,
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height * 2.2 / 10,
              child: Container(
                decoration: BoxDecoration(
                  color: cloudColor,
                  boxShadow: [BoxShadow(blurRadius: 0)],
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.height / 2,
                      100.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 30,
          left: 0,
          right: 0,
          child: AppBar(
            title: Text(
              'Cloud Walk',
              style: TextStyle(
                fontSize: 50.0,
                color: tanColor,
              ),
            ),
            backgroundColor:
            Colors.transparent, // Make the AppBar transparent
            elevation: 0, // Remove shadow
          ),
        ),
      ],
    );
  }
}

