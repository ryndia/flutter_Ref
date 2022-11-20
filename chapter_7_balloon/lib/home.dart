import 'package:flutter/material.dart';
import 'package:chapter_7_balloon/animated_balloon.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const <Widget>[
                AnimatedBalloonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
