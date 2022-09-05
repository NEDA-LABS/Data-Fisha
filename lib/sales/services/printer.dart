import 'package:flutter/services.dart';

class PrinterService {
  Future<String> posPrint(
      {String data, String printer, String id, String qr}) async {
    // await Future.delayed(const Duration(seconds: 3));
    // return await const MethodChannel('com.smartstock/printer').invokeMethod(
    //     'print', {"data": data, "printer": printer, "id": id, "qr": ''});
    return "done printing";
  }
}
