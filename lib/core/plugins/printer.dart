@JS()
library printer.js;

import 'package:js/js.dart';

@JS()
external dynamic hasDirectPosPrinterAPI();

@JS()
external dynamic directPosPrintAPI(String data, String qr);