import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:bus_prediction/home.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class popCard extends StatefulWidget {
  final Marker marker;
  final int index;

  const popCard(this.marker, this.index, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _popCardState(marker, index);
}

class _popCardState extends State<popCard> {
  final Marker _marker;
  final int index;

  _popCardState(this._marker, this.index);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => setState(() {
          fetchData();
        }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Icon(Icons.location_on),
            ),
            _cardDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          constraints: const BoxConstraints(minWidth: 100),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    busStopName.elementAt(busStopMarker.indexOf(_marker)),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                  Text(
                    'Estimated Arriving Time:${(arrivalTime.elementAt(busStopMarker.indexOf(_marker) - 1)) ==0?"Bus already passed":((arrivalTime.elementAt(busStopMarker.indexOf(_marker) - 1))).toString() +'min' }',
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    line.clear();
                    duplicateItems.clear();
                    setState(() {
                      selectIndex = 1;
                    });

                    checkBusStopLine(
                        busStopName.elementAt(busStopMarker.indexOf(_marker)));
                  })
            ],
          )),
    );
  }

  Future<void> fetchData() async {
    polyline.clear();
    List<LatLng> pl = [];
    final response = await http.get(Uri.parse(
        'https://api.mapbox.com/directions/v5/mapbox/walking/'
            '${currentLocation.point.longitude},${currentLocation.point.latitude};'
            '${_marker.point.longitude},${_marker.point.latitude}?geometries='
            'geojson&access_token=pk.eyJ1IjoicnluZGlhIiwiYSI6ImNsMnVmbG1xODAxaz'
            'YzYnBlbTJzMWljNG8ifQ.73UzfRptLs05Tg2_0zxY1w'));
    var data = jsonDecode(response.body);
    int length = data['routes'][0]['geometry']['coordinates'].length;
    for (int i = 0; i < length; i++) {
      LatLng temp = LatLng(data['routes'][0]['geometry']['coordinates'][i][1],
          data['routes'][0]['geometry']['coordinates'][i][0]);
      pl.add(temp);
    }
    if (polyline.isEmpty) {
      setState(() {
        polyline.addAll(pl);
      });
    }
  }

  void checkBusStopLine(String busStop) async {
    final db = FirebaseFirestore.instance;
    await db.collection('Bus Stop Line').get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == busStop) {
          setState(() {
            selectedValue3 = busStop;
          });
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
