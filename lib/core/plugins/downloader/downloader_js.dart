@JS()
library downloader.js;

import 'package:js/js.dart';

@JS()
external dynamic download(String data,String contentType,String filename);