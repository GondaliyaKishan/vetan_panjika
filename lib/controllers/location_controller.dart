import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class LocationController {
  Location location = Location();

  Future<bool> getLocationEnabled() async {
    bool _serviceEnabled = false;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    } else if (_serviceEnabled) {
      _serviceEnabled = true;
    }
    return _serviceEnabled;
  }

  Future<bool> getLocationAccess() async {
    bool hasPermission = false;
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        hasPermission = true;
      } else {
        _permissionGranted = await location.requestPermission();
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      hasPermission = true;
    }
    return hasPermission;
  }

  Future<LocationData?>getLocation() async {
    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (_serviceEnabled) {
        LocationData _locationData;
        _locationData = await location.getLocation().timeout(const Duration(seconds: 5));
        _locationData = _locationData;
        return _locationData;
      } else {
        return null;
      }
    } catch (e) {
       debugPrint(e.toString());
       LocationData _locationData;
       _locationData = LocationData.fromMap({
         "latitude": 0.0,
         "longitude": 0.0,
       });
      return _locationData;
    }
  }
}