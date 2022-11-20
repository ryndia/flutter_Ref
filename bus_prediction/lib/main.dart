import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';
import 'package:bus_prediction/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return ConnectionNotifier(
      child: MaterialApp(
      debugShowCheckedModeBanner: false, //remove the debug banner top-right
      title: 'Starter template',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0x1c243400),
        primarySwatch: Colors.yellow,
      ),
      home: const Home(),
    ));
  }
}
