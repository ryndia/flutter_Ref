import 'package:location/location.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:latlong2/latlong.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final List<String> items = [
  'UBS ltd',
  'NTC ltd',
  'RHT ltd',
  'TBS ltd',
  'Individual Company',
  'BOCS',
  'MBT',
  'Individual Operator BOCS',
  'Luna Transport',
  'NTA'
];
final List<String> route = [];
String? selectedValue;

class _HomeState extends State<Home> {
  final MapController _mapController = MapController();
  bool infoWindowVisible = false;
  bool currentLatlngState = false;
  LatLng markerCoords = LatLng(-20.164444, 57.504167);
  double infoWindowOffset = 0.002;
  late LatLng infoWindowCoords;
  LatLng currentLatLng = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    infoWindowCoords = LatLng(
      markerCoords.latitude + infoWindowOffset,
      markerCoords.longitude,
    );
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    currentLatlngState = true;
  } //idk

  @override
  Widget build(BuildContext context) {
    initializeLocationAndSave();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Prediction'),
      ),
      body: SlidingSheet(
        elevation: 2,
        cornerRadius: 16,
        snapSpec: const SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          snappings: [0.05, 0.7, 1],
          // Define to what the snappings relate to. In this case,
          // the total available space that the sheet can expand to.
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: FlutterMap(
          mapController: _mapController,
          options: MapOptions(zoom: 16.0, minZoom: 5),
          layers: [
            TileLayerOptions(
              urlTemplate:
              'https://api.mapbox.com/styles/v1/ryndia/cl2ufqabn000q15l0t0z53bzn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnluZGlhIiwiYSI6ImNsMnVmbG1xODAxazYzYnBlbTJzMWljNG8ifQ.73UzfRptLs05Tg2_0zxY1w',
              additionalOptions: {
                'accessToken':
                'pk.eyJ1IjoicnluZGlhIiwiYSI6ImNsMnVmbG1xODAxazYzYnBlbTJzMWljNG8ifQ.73UzfRptLs05Tg2_0zxY1w',
              },
            ),
            MarkerLayerOptions(
              markers: [
                if (infoWindowVisible)
                  Marker(
                    width: 200.0,
                    height: 200.0,
                    point: infoWindowCoords,
                    builder: (BuildContext ctx) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            infoWindowVisible = false;
                          });
                        },
                        child: Container(color: Colors.yellow),
                      );
                    },
                  ),
                Marker(
                  point: markerCoords,
                  builder: (BuildContext ctx) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          infoWindowVisible = true;
                        });
                      },
                      child: const Icon(Icons.directions_bus,
                          size: 50.0, color: Colors.white),
                    );
                  },
                ),
                if (currentLatlngState)
                  Marker(
                    point: currentLatLng,
                    builder: (BuildContext ctx) {
                      return const Icon(Icons.location_on_rounded,
                          size: 40.0, color: Colors.white);
                    },
                  ),
              ],
            )
          ],
        ),
        builder: (context, state) {
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return SizedBox(
            height: 400,
            child: Column(
              children: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {

                        selectedValue = value as String;
                        /*final
                            db = FirebaseFirestore.instance;
                            final docRef = db.collection(selectedValue!).doc("Line 44 Curepipe To Camp Les Juges");
                            docRef.get().then(
                                  (DocumentSnapshot doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                print(data);
                              },
                              onError: (e) => print("Error getting document: $e"),
                            );*/
                      });
                    },
                    buttonHeight: 40,
                    buttonWidth: 150,
                    itemHeight: 40,
                  ),
                ),

                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Select Item',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: route
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonHeight: 40,
                    buttonWidth: 150,
                    itemHeight: 40,
                  ),
                ),
                Row(
                  children: const [
                    SizedBox(height: 200, child: Text('Passenger Count:')),
                    SizedBox(height: 200, child: Text('Estimate Time:'))
                  ],
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        onPressed: () {
          if(!currentLatlngState)
          {
            initializeLocationAndSave();
          }
          _mapController.move(currentLatLng, 16);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.tram), label: "Bus Location"),
          BottomNavigationBarItem(
              icon: Icon(Icons.price_check), label: "Bus Info"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: "User Spk duh"),
        ],
        onTap: (selectedIndex) => _changePage(selectedIndex),
      ),
    );
  }

  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get capture the current user location
    LocationData _locationData = await _location.getLocation();
    currentLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);
    currentLatlngState = true;
    // Store the user location in sharedPreferences
    //sharedPreferences.setDouble('latitude', _locationData.latitude!);
    //sharedPreferences.setDouble('longitude', _locationData.longitude!);
  }

  void retrieveBusCompanyList()
  {

  }
}

_changePage(int selectedIndex) {}
