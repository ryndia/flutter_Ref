import 'package:flutter/material.dart';
import 'package:chapter_8/gratitude.dart';

class Home extends StatefulWidget
{
  const Home({Key? key,}):super(key:key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  String howAreYou = "...";

  void _openPageGratitude({ BuildContext? context, bool fullscreenDialog = false}) async
  {
    final String _gratitudeResponse = await Navigator.push(
      context!,
      MaterialPageRoute(
        fullscreenDialog: fullscreenDialog,
        builder: (context) => const Gratitude(
          radioGroupValue: -1,
        ),
      ),
    );
    howAreYou = _gratitudeResponse ?? '';
  }
  @override
  Widget build(BuildContext context)
  {
    print(howAreYou);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openPageGratitude(context:context),
        tooltip: 'About',
        child: const Icon(Icons.sentiment_satisfied),
      ),
      appBar: AppBar(
        title: const Text('navigator'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: (){
              context: context;
              fullScreenDialog: true;
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(padding:const EdgeInsets.all(16.0),
          child: Text('Your GRATEFUL for $howAreYou',
            style: const TextStyle(
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}