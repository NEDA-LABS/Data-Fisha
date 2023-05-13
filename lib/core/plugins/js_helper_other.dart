class JSHelper {
  /// This method name inside 'getPlatform' should be same in JavaScript file
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
