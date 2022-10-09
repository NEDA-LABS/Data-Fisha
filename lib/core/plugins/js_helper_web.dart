import 'package:js/js_util.dart';

import 'printer.dart';

class JSHelper {
  Future<bool> callHasDirectPosPrinterAPI() async {
    return await promiseToFuture(hasDirectPosPrinterAPI());
  }

  Future<String> callDirectPosPrintAPI(String data, String qr) async {
    return await promiseToFuture(directPosPrintAPI(data, qr));
  }
}
