// THIS FILE WILL PREVENT COMPILE TIME ERRORS,
// WHICH OCCURS BECAUSE OF PLATFORM DEPENDENT IMPORTS...

export 'js_helper_other.dart' // By default
    if (dart.library.js) 'js_helper_web.dart'
    if (dart.library.io) 'js_helper_other.dart';

