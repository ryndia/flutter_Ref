import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:location/location.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_prediction/popCard.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

final List<String> items = [
  'UBS Ltd',
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
final List<String> line = [];
final List<String> duplicateItems = [];
List<Marker> busStopMarker = [];
final List<String> busStopList = [];
final List<String> busStopName = [];
final List<LatLng> polyline = [];
late final MarkerLayerOptions mk;
final List<int> arrivalTime = [];
bool infoWindowVisible = false;

late Marker currentLocation;

String? selectedValue;
String? selectedValue2;
String? selectedValue3;
int selectIndex = 0;

class _HomeState extends State<Home> {
  final MapController _mapController = MapController();
  final PopupController _popupLayerController = PopupController();
  bool currentLatlngState = false;
  LatLng markerCoordinates = LatLng(-20.164444, 57.504167);
  double infoWindowOffset = 0.002;
  late LatLng infoWindowCoords;
  LatLng currentLatLng = LatLng(0, 0);
  int passengerCount = 0;
  SheetController sh = SheetController();
  bool flagSlide = false;

  @override
  void initState() {
    super.initState();
    line.addAll(duplicateItems);
    infoWindowCoords = LatLng(
      markerCoordinates.latitude + infoWindowOffset,
      markerCoordinates.longitude,
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
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit Application'),
              content: const Text('Do you want to exit the Application?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    initializeLocationAndSave();
    return WillPopScope(
        onWillPop: showExitPopup, //call function on back button press
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Bus Prediction'),
          ),
          body: SlidingSheet(
            elevation: 2,
            cornerRadius: 16,
            controller: sh,
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
              options: MapOptions(
                  zoom: 12.0,
                  center: LatLng(-20.1619400, 57.4988900),
                  minZoom: 5,
                  onTap: (_, __) => _popupLayerController.hideAllPopups()),
              children: [
                TileLayerWidget(
                  options: TileLayerOptions(
                    urlTemplate:
                        'https://api.mapbox.com/styles/v1/ryndia/cl2ufqabn000q15l0t0z53bzn/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoicnluZGlhIiwiYSI6ImNsMnVmbG1xODAxazYzYnBlbTJzMWljNG8ifQ.73UzfRptLs05Tg2_0zxY1w',
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoicnluZGlhIiwiYSI6ImNsMnVmbG1xODAxazYzYnBlbTJzMWljNG8ifQ.73UzfRptLs05Tg2_0zxY1w',
                    },
                  ),
                ),
                PolylineLayerWidget(
                    options: PolylineLayerOptions(
                        // Will only render visible polylines, increasing performance
                        polylines: [
                      Polyline(
                        points: polyline,
                        color: const Color(0xFF669DF6),
                        strokeWidth: 5.0,
                        borderColor: const Color(0xFF1967D2),
                        borderStrokeWidth: 0.1,
                        // An optional tag to distinguish polylines in `onTap` callback
                        // ...all other Polyline options
                      ),
                    ])),
                PopupMarkerLayerWidget(
                  options: PopupMarkerLayerOptions(
                    popupController: _popupLayerController,
                    markers: busStopMarker,
                    markerRotateAlignment:
                        PopupMarkerLayerOptions.rotationAlignmentFor(
                            AnchorAlign.top),
                    popupBuilder: (BuildContext context, Marker marker) =>
                        popCard(marker, busStopMarker.indexOf(marker)),
                  ),
                )
              ],
            ),
            builder: (context, state) {
              // This is the content of the sheet that will get
              // scrolled, if the content is bigger than the available
              // height of the sheet.
              return choiceSpace();
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.my_location),
            onPressed: () {
              if (!currentLatlngState) {
                initializeLocationAndSave();
              }
              _mapController.move(currentLatLng, 16);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_bus), label: "Bus Location"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_bulleted_sharp),
                  label: "Bus Info"),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: selectIndex,
            selectedItemColor: Colors.yellow,
            unselectedItemColor: Colors.grey,
            elevation: 5,
            onTap: (selectedIndex) {
              retrievebusstoplist();
              setState(() {
                if (flagSlide && selectedIndex == selectIndex) {
                  sh.collapse();
                  flagSlide = false;
                } else {
                  sh.expand();
                  flagSlide = true;
                }
                selectIndex = selectedIndex;
              });
            },
          ),
        ));
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

    currentLocation = Marker(
      point: currentLatLng,
      builder: (BuildContext ctx) {
        return GestureDetector(
            onTap: () {},
            child: const Icon(Icons.location_on_rounded,
                size: 40.0, color: Colors.white));
      },
    );
    if (!currentLatlngState) {
      setState(() {
        busStopMarker.insert(0, currentLocation);
        busStopName.insert(0, "Your Current location");
        arrivalTime.insert(0, 0);
      });
      currentLatlngState = true;
    }
  }

  void retrieveBusCompanyList() async {
    final db = FirebaseFirestore.instance;
    String valueBus = selectedValue as String;

    setState(() {
      passengerCount = 0;
      route.clear();
      selectedValue2 = null;
      busStopName.clear();
      busStopName.insert(0, "Your Current location");
      arrivalTime.clear();
      busStopMarker.clear();
      busStopMarker.insert(0, currentLocation);
      arrivalTime.insert(0, 0);
    });
    //busStopMarker.add(currentLocation);
    await db.collection(valueBus).get().then((event) {
      for (var doc in event.docs) {
        if (route.contains(doc.id) == false) {
          setState(() {
            route.add(doc.id);
          });
        }
      }
    });
  }

  void displayBusStop() async {
    busStopName.clear();
    busStopName.insert(0, "Your Current location");
    busStopMarker.clear();
    busStopMarker.insert(0, currentLocation);
    final db = FirebaseFirestore.instance;
    String valueBus = selectedValue as String;
    await db.collection(valueBus).get().then((event) {
      for (var doc in event.docs) {
        if (selectedValue2 == doc.id) {
          int size = doc.data().length;
          for (int i = 1; i <= size - 2; i++) {
            setState(() {
              GeoPoint location = doc.data()['Bus_Stop_$i'][1];
              busStopName.add(doc.data()['Bus_Stop_$i'][0]);

              LatLng templatlng = LatLng(location.latitude, location.longitude);
              LatLng? center;
              if (i == (((size - 2) / 2).round())) {
                center = templatlng;
              }
              busStopMarker.add(Marker(
                point: templatlng,
                builder: (BuildContext ctx) {
                  return const Icon(Icons.directions_bus,
                      size: 30.0, color: Colors.yellow);
                },
              ));
              if (center != null) {
                _mapController.move(center, 15);
              }
            });
          }
        }
      }
    });
  }

  SizedBox choiceSpace() {
    if (selectIndex == 0) {
      return SizedBox(
        height: 400,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Bus Company',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String;
                    route.clear();
                  });
                  retrieveBusCompanyList();
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonWidth: 320,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 360,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Row(
                  children: const [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Bus Line',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: route
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue2,
                onChanged: (value) {
                  setState(() {
                    infoWindowVisible = false;
                    selectedValue2 = value as String;
                    displayBusStop();
                    retrieveTime();
                    sh.collapse();
                    flagSlide = false;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: Colors.yellow,
                iconDisabledColor: Colors.grey,
                buttonHeight: 50,
                buttonWidth: 320,
                buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                buttonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                ),
                buttonElevation: 2,
                itemHeight: 40,
                itemPadding: const EdgeInsets.only(left: 14, right: 14),
                dropdownMaxHeight: 200,
                dropdownWidth: 360,
                dropdownPadding: null,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                dropdownElevation: 8,
                scrollbarRadius: const Radius.circular(40),
                scrollbarThickness: 6,
                scrollbarAlwaysShow: true,
                offset: const Offset(-20, 0),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(
                        height: 20,
                        child: Text(
                          'Number of Passenger:',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 200,
                        child: Text('$passengerCount',
                            style: const TextStyle(
                              fontSize: 200.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.grey,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            )))
                  ],
                )
              ],
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 400,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Row(
                children: const [
                  Icon(
                    Icons.list,
                    size: 16,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      'Select Bus Stop',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: busStopList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue3,
              onChanged: (value) {
                setState(() {
                  selectedValue3 = value as String;
                });
                checkBusStopLine(selectedValue3 as String);
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
              buttonHeight: 50,
              buttonWidth: 320,
              buttonPadding: const EdgeInsets.only(left: 14, right: 14),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
              ),
              buttonElevation: 2,
              itemHeight: 40,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownWidth: 360,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              dropdownElevation: 8,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              offset: const Offset(-20, 0),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: line.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(
                        Icons.directions_bus_sharp,
                        color: Colors.grey,
                      ),
                      title: Text(line[index]),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void retrieveTime() {
    final db = FirebaseFirestore.instance;
    String valueBus = selectedValue as String;
    String line = selectedValue2 as String;
    final docRef = db.collection(valueBus).doc(line);
    docRef.snapshots().listen(
      (event) {
        Map<String, dynamic> data = event.data()!;
        setState(() {
        GeoPoint liveLocation = data['Live_Location'];
        passengerCount = data['Occupancy'];
        LatLng liveLatLng =
            LatLng(liveLocation.latitude, liveLocation.longitude);
        if(busStopMarker.length >1){
        busStopMarker.removeAt(1);}
        busStopMarker.insert(
            1,
            Marker(
              point: liveLatLng,
              anchorPos: AnchorPos.align(AnchorAlign.top),
              builder: (BuildContext ctx) {
                return GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.location_on,
                        size: 50.0, color: Colors.red));
              },
            ));});
        arrivalTime.clear();
        arrivalTime.insert(0,0);
        for (int i = 1; i < data.length - 1; i++) {
          if (data['Bus_Stop_$i'][2] == null) {
            setState(() {
            arrivalTime.add(0);});
          } else {
            setState(() {
            arrivalTime.add(data['Bus_Stop_$i'][2]);});
          }
        }
      },
      onError: (error) => print("Listen failed: $error"),
    );
    busStopName.insert(1, "Live Bus Location");
    arrivalTime.insert(1, 1);
    print(busStopMarker);
    print(arrivalTime);
  }

  void retrievebusstoplist() async {
    busStopList.clear();
    final db = FirebaseFirestore.instance;
    await db.collection('Bus Stop Line').get().then((event) {
      for (var doc in event.docs) {
        setState(() {
          busStopList.add(doc.id);
        });
      }
    });
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = <String>[];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = <String>[];
      for (var item in dummySearchList) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      }
      setState(() {
        line.clear();
        line.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        line.clear();
        line.addAll(duplicateItems);
      });
    }
  }

  void checkBusStopLine(String busStop) async {
    final db = FirebaseFirestore.instance;
    await db.collection('Bus Stop Line').get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == busStop) {
          for (int i = 0; i < doc.data()['Bus Line'].length; ++i) {
            setState(() {
              line.add(doc.data()['Bus Line'][i]);
              duplicateItems.add(doc.data()['Bus Line'][i]);
            });
          }
        }
      }
    });
  }
}
