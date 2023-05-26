import 'package:js/js_util.dart';

import './printer_js.dart';

class PrinterPlugin {
  Future<bool> callHasDirectPosPrinterAPI() async {
    return await promiseToFuture(hasDirectPosPrinterAPI());
  }

  Future<String> callDirectPosPrintAPI(String data, String qr) async {
    return await promiseToFuture(directPosPrintAPI(data, qr));
  }
}
