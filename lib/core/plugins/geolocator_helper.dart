export 'geolocator_web.dart' // By default
if (dart.library.js) 'geolocator_web.dart'
if (dart.library.io) 'geolocator_io.dart';