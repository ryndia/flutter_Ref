import 'package:flutter/material.dart';
import 'package:virtual_neo_gps/Home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false, //remove the debug banner top-right
          title: 'Virtual Neo Gps',
          theme: ThemeData(
            //scaffoldBackgroundColor: const Color(0xFFFFFF00),
            primarySwatch: Colors.blueGrey,
          ),
          home: const Home(),
    );
  }
}
