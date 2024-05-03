import 'dart:developer';

import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHandler {
  final Location _location = Location();

  Future<LatLng?> getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        log("Location services is not available");
        return null;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        log("Location permission is denied");
        return null;
      }
    }

    locationData = await _location.getLocation();
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<geo.Placemark?> getPlacemark(double lat, double lon) async {
    final info = await geo.placemarkFromCoordinates(lat, lon);
    return info.isNotEmpty ? info[0] : null;
  }
}
