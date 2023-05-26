export 'sync_io.dart' // By default
if (dart.library.js) 'sync_web.dart'
if (dart.library.io) 'sync_io.dart';
