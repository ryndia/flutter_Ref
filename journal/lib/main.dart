import 'package:flutter/material.dart';
import 'package:journal/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.red,
        bottomAppBarColor: Colors.red,
      ),
      home: Home(),
    );
  }
}
