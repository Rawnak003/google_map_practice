import 'dart:ui';

import 'package:location/location.dart';

class LocatorService {
  LocationData? currentLocation;

  Future<void> getCurrentLocation(VoidCallback onLocationUpdated) async {
    _onLocationPermissionAndServiceEnabled(() async {
      LocationData locationData = await Location.instance.getLocation();
      currentLocation = locationData;
      onLocationUpdated();
    }, onLocationUpdated);
  }

  Future<void> listenCurrentLocation(VoidCallback onLocationUpdated) async {
    _onLocationPermissionAndServiceEnabled(() {
      Location.instance.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 10000, // Fetch the user current location after every 10 seconds
      );
      Location.instance.onLocationChanged.listen((LocationData location) {
        currentLocation = location;
        onLocationUpdated();
      });
    }, onLocationUpdated);
  }

  Future<void> _onLocationPermissionAndServiceEnabled(VoidCallback onSuccess, VoidCallback onLocationUpdated) async {
    bool isPermissionEnabled = await _isLocationPermissionEnabled();
    if (isPermissionEnabled) {
      bool isGpsServiceEnabled = await Location.instance.serviceEnabled();
      if (isGpsServiceEnabled) {
        onSuccess();
      } else {
        Location.instance.requestService();
      }
    } else {
      bool isPermissionGranted = await _requestPermission();
      if (isPermissionGranted) {
        getCurrentLocation(onLocationUpdated);
        listenCurrentLocation(onLocationUpdated);
      }
    }
  }

  Future<bool> _isLocationPermissionEnabled() async {
    PermissionStatus permission = await Location.instance.hasPermission();
    if (permission == PermissionStatus.granted || permission == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _requestPermission() async {
    PermissionStatus permission = await Location.instance.requestPermission();
    if (permission == PermissionStatus.granted || permission == PermissionStatus.grantedLimited) {
      return true;
    } else {
      return false;
    }
  }
}