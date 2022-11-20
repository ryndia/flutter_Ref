import 'package:flutter/material.dart';
import 'package:bus_prediction_fyp/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
      (
      debugShowCheckedModeBanner: false, //remove the debug banner top-right
      title: 'Starter template',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const Home(),
    );
  }
}