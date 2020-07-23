class PrinterService {
  Future<String> posPrint(
      {String data, String printer, String id, String qr}) async {
    // call printer plugin
    print(data);
    print(printer);
    print(id);
    print(qr);
    return 'Done';
  }
}
