import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget{
  final int index;
  const HeaderWidget({Key? key, required this.index}):super(key:key);

  @override
  Widget build(BuildContext context)
  {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 120.0,
      child: Card(
        elevation: 8.0,
        color: Colors.purple,
        shape: StadiumBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('JAPAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48.0,
                color: Colors.lightGreen,
              ),
            ),
            const Text('travel plans',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

