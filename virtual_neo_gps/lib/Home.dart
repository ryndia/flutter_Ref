import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:wakelock/wakelock.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng currentLatLng = const LatLng(0, 0);
  final CountDownController _controller = CountDownController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
    Wakelock.enable();
    initializeLocationAndSave();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Virtual Neo Gps',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          children:<Widget> [
            SizedBox(
                height:  50
            ),
          SizedBox(
              child: Text(
                'latitude: ${currentLatLng.latitude}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )
          ),
            SizedBox(
              height: 10
            ),
            SizedBox(
                child: Text(
                  'longitude: ${currentLatLng.longitude}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                )
            ),
          CircularCountDownTimer(
          duration: 300,
          initialDuration: 0,
          controller: _controller,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          ringColor: Colors.grey[300]!,
          ringGradient: null,
          fillColor: Colors.redAccent[100]!,
          fillGradient: null,
          backgroundColor: Colors.red[500],
          backgroundGradient: null,
          strokeWidth: 20.0,
          strokeCap: StrokeCap.round,
          textStyle: const TextStyle(
              fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.S,
          isReverse: false,
          isReverseAnimation: false,
          isTimerTextShown: true,
          autoStart: true,
          onStart: () {
            debugPrint('Countdown Started');
          },
          onComplete: () {
            debugPrint('Countdown Ended');
            setState(() {
              initializeLocationAndSave();
              upload();
            });
          },
          onChange: (String timeStamp) {
            //debugPrint('Countdown Changed $timeStamp');
          },
        ),
          const SizedBox(
              child: Text(
                'Hello I m the virtual Neo GPS,\ngoing to upload gps data from\n a phone at an interval of 5min \nas my physical body\n wont work in mauritius ',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              )
          ),
        ],
        ),
      ),
    );
  }

  void upload() {
    //neo_virtual_gps/upload_live_location
    final db = FirebaseFirestore.instance;
    var location = GeoPoint(currentLatLng.latitude, currentLatLng.longitude);
    db
        .collection("neo_virtual_gps")
        .doc("upload_live_location")
        .set({"live_location":location})
        .onError((e, _) => print("Error writing document: $e"));
    _controller.start();
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);
  }
}
