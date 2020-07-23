import 'package:flutter/services.dart';

class PrinterService {
  Future<String> posPrint(
      {String data, String printer, String id, String qr}) async {
    // call printer plugin
//    await Future.delayed(Duration(seconds: 5));
    return await MethodChannel('com.smartstock/printer').invokeMethod(
        'print', {"data": data, "printer": printer, "id": id, "qr": ''});
  }
}
