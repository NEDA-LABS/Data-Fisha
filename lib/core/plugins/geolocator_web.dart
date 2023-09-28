import 'package:flutter/foundation.dart';
import 'package:geolocator_web/geolocator_web.dart' as geo_web;

ensureGeolocatorWeb(){
  try{
    return geo_web.ServiceStatus.values;
  }catch(e){
    if (kDebugMode) {
      print(e);
    }
  }
}