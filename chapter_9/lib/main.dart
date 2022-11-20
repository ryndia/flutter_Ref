import 'package:flutter/material.dart';
import 'package:chapter_9/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'hello world',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Home(),
    );
  }
}