import 'package:flutter/material.dart';
import 'const.dart';
import 'welcomePage.dart';
import 'upload.dart';

class WelcomeTransition extends StatelessWidget {
  const WelcomeTransition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      controller: controller,
      scrollDirection: Axis.vertical,
      children: [
        WelcomeTransitionPage(controller: controller),
        WelcomePage(),
      ],
    );
  }
}

class WelcomeTransitionPage extends StatelessWidget {
  const WelcomeTransitionPage({Key? key, required this.controller}) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: cloudColor,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                controller.animateToPage(
                  1, // Index of the WelcomePage in the PageView
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tanColor,
                fixedSize: const Size(200.0, 60.0),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

