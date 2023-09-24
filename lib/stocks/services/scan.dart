import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

Future readBarAndQRCode(InputImage inputImage)async{
  final List<BarcodeFormat> formats = [BarcodeFormat.all];
  final barcodeScanner = BarcodeScanner(formats: formats);
  final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);
  return barcodes.isNotEmpty?barcodes[0].rawValue:throw Exception('nothing');
  // for (Barcode barcode in barcodes) {
  //   final BarcodeType type = barcode.type;
  //   final Rect? boundingBox = barcode.boundingBox;
  //   final String displayValue = barcode.displayValue??'';
  //   final String rawValue = barcode.rawValue??'';
  //   print(rawValue);
  //   // See API reference for complete list of supported types
  //   // switch (type) {
  //   //   case BarcodeType.wifi:
  //   //     BarcodeWifi barcodeWifi = barcode.value;
  //   //     break;
  //   //   case BarcodeValueType.url:
  //   //     BarcodeUrl barcodeUrl = barcode.value;
  //   //     break;
  //   // }
  // }
}
