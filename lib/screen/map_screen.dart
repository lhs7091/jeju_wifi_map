import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jeju_wifi_map/db/db_helper.dart';

import 'package:jeju_wifi_map/model/data_model.dart';

class MapScreen extends StatefulWidget {
  List<Data> detailDataList;
  MapScreen({Key key, this.detailDataList}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var googleMapServices;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  Position position;
  LatLng _initTarget;
  bool _initLoading = false;

  List<Data> _dataList;

  @override
  void initState() {
    // DB info check
    _dataList = this.widget.detailDataList;

    setState(() {
      _dataList.forEach((element) {
        _markers.add(Marker(
          markerId: MarkerId(element.installLocationDetail),
          position: LatLng(
              double.parse(element.latitude), double.parse(element.longitude)),
          infoWindow: InfoWindow(
            title: '${element.installLocationDetail}',
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ));
      });
    });

    _checkGPSAvailability();

    _getGPSLocation().then((value) {
      setState(() {
        //_initTarget = LatLng(position.latitude, position.longitude);
        _initTarget = LatLng(33.50972, 126.52194);
        _initLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _initLoading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _initTarget, //LatLng(35.700620, 139.914172),
                        zoom: 14,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      myLocationEnabled: true,
                      markers: _markers,
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  void _checkGPSAvailability() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    print(geolocationStatus);

    if (geolocationStatus != GeolocationStatus.granted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('GPS 사용 불가'),
            content: Text('GPS 사용 불가로 앱을 사용할 수 없습니다'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        },
      ).then((_) => Navigator.pop(context));
    }
  }

  Future<void> _getGPSLocation() async {
    position = await Geolocator().getCurrentPosition();
    print('latitude: ${position.latitude}, longitude: ${position.longitude}');
  }
}
