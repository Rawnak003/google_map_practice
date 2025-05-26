//TODO: set a initial camera position
//TODO: create the locator service class
//TODO: get the current location and set it to initial location
//TODO: listen for location updates
//TODO: update the map utils (markers, polylines, camera, prevLocation, currentLocation) according to the updates
//TODO: animate the camera to the new location
//TODO: set the current location as the previous location since new location is the current location now

import 'package:flutter/material.dart';
import 'package:google_map/locator_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _mapController;
  final LocatorService _locatorService = LocatorService();
  bool _initialLocationSet = false;
  LatLng? _prevLocation;
  int _polylineIdCounter = 1;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _locatorService.getCurrentLocation(() {
      final location = _locatorService.currentLocation;
      if (location != null) {
        final latLng = LatLng(location.latitude!, location.longitude!);
        _updateMapUtils(latLng);
        _initialLocationSet = true;
      }
    });

    _locatorService.listenCurrentLocation(() {
      final location = _locatorService.currentLocation;
      print('Location updated: $location');
      if (location != null) {
        final latLng = LatLng(location.latitude!, location.longitude!);
        _updateMapUtils(latLng);
      }
    });
  }

  void _updateMapUtils(LatLng currentLatLng) {
    if (_prevLocation != null) {
      final newPolyline = Polyline(
        polylineId: PolylineId('route-${_polylineIdCounter++}'),
        points: [_prevLocation!, currentLatLng],
        color: Colors.blue.shade800,
        width: 8,
      );
      _polylines.add(newPolyline);
    }

    _markers.removeWhere((marker) => marker.markerId.value == 'my-location');
    _markers.add(
      Marker(
        markerId: const MarkerId('my-location'),
        position: currentLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: 'My current location',
          snippet: 'Lat: ${currentLatLng.latitude}, Lng: ${currentLatLng.longitude}',
        ),
      ),
    );

    if (!_initialLocationSet) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentLatLng,
            zoom: 17,
          ),
        ),
      );
      _initialLocationSet = true;
    } else {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(currentLatLng),
      );
    }

    _prevLocation = currentLatLng;
    setState(() {});
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Real-Time Location Tracker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.41229521245854, -122.07818750292063),
          zoom: 17,
        ),
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}