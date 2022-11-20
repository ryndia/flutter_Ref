import 'package:flutter/material.dart';

class Home extends StatefulWidget
{
  const Home({Key? key,}): super(key:key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>
{
  String _gestureDetected = 'gesture';
   Color _paintedColor = Colors.black;
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildGestureDetector(),
                Divider(
                  color: Colors.black,
                  height: 44.0,
                ),
                _buildDraggable(),
                Divider(
                  height:40.0,
                ),
                _buildDragTarget(),
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
    );
  }

  GestureDetector _buildGestureDetector(){
    return GestureDetector(
      onTap: () {
        print('onTap');
        _displayGestureDetected('onTap');
      },
      onDoubleTap: () {
        print('onDoubleTap');
        //Setting Up GestureDetector: The Basics ❘ 273
        _displayGestureDetected('onDoubleTap');
      },
      onLongPress: () {
        print('onLongPress');
        _displayGestureDetected('onLongPress');
      },
      onPanUpdate: (DragUpdateDetails details) {
        print('onPanUpdate: $details');
        _displayGestureDetected('onPanUpdate:\n$details');
      },
      //onVerticalDragUpdate: ((DragUpdateDetails details) {
      // print('onVerticalDragUpdate: $details');
      // _displayGestureDetected('onVerticalDragUpdate:\n$details');
      //}),
      //onHorizontalDragUpdate: (DragUpdateDetails details) {
      // print('onHorizontalDragUpdate: $details');
      // _displayGestureDetected('onHorizontalDragUpdate:\n$details');
      //},
      //onHorizontalDragEnd: (DragEndDetails details) {
      // print('onHorizontalDragEnd: $details');
      // if (details.primaryVelocity < 0) {
      // print('Dragging Right to Left: ${details.velocity}');
      // } else if (details.primaryVelocity > 0) {
      // print('Dragging Left to Right: ${details.velocity}');
      // }
      //},
      child: Container(
        color: Colors.lightGreen.shade100,
        width: double.infinity,
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.access_alarm,
              size: 98.0,
            ),
            Text('$_gestureDetected'),
          ],
        ),
      ),
    );
  }
  void _displayGestureDetected(String gesture) {
    setState(() {
      _gestureDetected = gesture;
    });
  }

  Draggable<int> _buildDraggable()
  {
    return Draggable(
      child: Column(
        children: const <Widget> [
          Icon(
            Icons.palette,
            color: Colors.orange,
            size: 48.0,
          ),
          Text(
            'Drag to change color',
          ),
        ],
      ),
      childWhenDragging: Icon(
        Icons.palette,
        color: Colors.grey,
        size: 48.0,
      ),
      feedback: Icon(
        Icons.brush,
        color: Colors.orange,
        size: 80.0,
      ),
      data: Colors.orange.value,
    );
  }

  DragTarget<int> _buildDragTarget()
  {
    return DragTarget<int> (
        onAccept: (colorValue)
        {
          _paintedColor = Color(colorValue);
        },
        builder: (BuildContext context, List<dynamic> acceptedData, List<dynamic> rejectedData) => acceptedData.isEmpty ? Text(
      'Drag to see color change',
      style: TextStyle(
          color: (_paintedColor),
      ),
    )
        :Text('painting color: $acceptedData',
        style: TextStyle(
          color: Color(acceptedData[0]),
          fontWeight: FontWeight.bold,
        )
    ),
    );
  }
}

