export './printer_io.dart' // By default
    if (dart.library.js) 'printer_web.dart'
    if (dart.library.io) 'printer_io.dart';

