import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyPosition extends StatefulWidget {
  @override
  _MyPositionState createState() => _MyPositionState();
}

class _MyPositionState extends State<MyPosition> {
  GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController ctl) {
    _controller = ctl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(40.712776, -74.005974), zoom: 12),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: true,
          ),
        ],
      ),
    );
  }
}
