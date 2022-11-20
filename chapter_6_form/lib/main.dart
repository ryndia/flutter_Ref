import 'package:chapter_6_form/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
      (
      debugShowCheckedModeBanner: false, //remove the debug banner top-right
      title: 'Starter template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}
