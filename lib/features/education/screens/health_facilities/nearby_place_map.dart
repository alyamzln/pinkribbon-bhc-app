import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyPlaceMap extends StatefulWidget {
  const NearbyPlaceMap({super.key});

  @override
  State<NearbyPlaceMap> createState() => _NearbyPlaceMapState();
}

class _NearbyPlaceMapState extends State<NearbyPlaceMap> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng? _currentLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      // Handle permission denial
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _moveCameraToCurrentLocation();
  }

  Future<void> _moveCameraToCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    if (_currentLocation != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation!, zoom: 14.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Health Facilities',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        elevation: 20,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 180.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              SizedBox(width: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
              )
            ],
          ),
        ));
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {marker1}),
    );
  }
}

Marker marker1 = Marker(
  markerId: MarkerId('marker_1'),
  position: LatLng(40.742451, -74.040413),
  infoWindow: InfoWindow(title: 'marker_1'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueMagenta,
  ),
);
