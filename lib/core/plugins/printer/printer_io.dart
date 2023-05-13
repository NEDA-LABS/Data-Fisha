class PrinterPlugin {
  String getPlatformFromJS() {
    return '';
  }

  Future<bool> callHasDirectPosPrinterAPI() async {
    return false;
  }

  Future<String> callDirectPosPrintAPI(String data, String qr) async {
    throw {'message': 'not printed'};
  }
}
