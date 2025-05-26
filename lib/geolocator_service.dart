import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  Future<void> getCurrentLocation() async {
    bool isPermissionEnabled = await _isLocationPermissionEnabled();
    if (isPermissionEnabled) {
      bool isGpsServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (isGpsServiceEnabled) {
        Position position = await Geolocator.getCurrentPosition();
        print(position);
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      bool isPermissionGranted = await _requestPermission();
      if (isPermissionGranted) {
        await getCurrentLocation();
      }
    }
  }

  Future<bool> _isLocationPermissionEnabled() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      return true;
    } else {
      return false;
    }
  }
}