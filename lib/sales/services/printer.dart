

class PrinterService {
  Future<String> posPrint(
      {String data, String printer, String id, String qr}) async {
    // call printer plugin
    // await Future.delayed(Duration(seconds: 3));
    // return await const MethodChannel('com.smartstock/printer').invokeMethod(
    //     'print', {"data": data, "printer": printer, "id": id, "qr": ''});
    return "done printing";
  }
}
