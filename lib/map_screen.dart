import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _googleMap(),
          _myLocation(),
        ],
      ),
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      mapToolbarEnabled: true,
      initialCameraPosition:
          (CameraPosition(target: LatLng(37.0, -74.0), zoom: 10)),
      myLocationButtonEnabled: true,
      markers: {newyork1Marker},
    );
  }

  Widget _myLocation() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: IconButton(
          onPressed: () {
            print("mylocation");
          },
          icon: Icon(
            Icons.my_location,
          ),
          iconSize: 30.0,
          color: Colors.black54,
        ),
      ),
    );
  }
}

Marker newyork1Marker = Marker(
  markerId: MarkerId('newyork1'),
  position: LatLng(40.712776, -74.005974),
  infoWindow: InfoWindow(
    title: 'Los Tacos',
  ),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
);
