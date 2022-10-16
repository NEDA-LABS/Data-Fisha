import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smartstock/core/plugins/js_helper.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

var _getShopSettings =
    propertyOr('settings', (p0) => {'saleWithoutPrinter': false});
var _getMustPrint = compose(
    [propertyOr('saleWithoutPrinter', (p0) => false), _getShopSettings]);
var _getPrinterHeader =
    compose([propertyOr('printerHeader', (p0) => '\n'), _getShopSettings]);
var _getPrinterFooter =
    compose([propertyOr('printerFooter', (p0) => '\n'), _getShopSettings]);

Future<String> posPrint({
  String data = '',
  String qr = '',
  appendHeaderFooter = true,
  force = false,
}) async {
  var currentShop = await getActiveShop();
  if (_getMustPrint(currentShop) == false || force) {
    var header = _getPrinterHeader(currentShop);
    var footer = _getPrinterFooter(currentShop);
    data = appendHeaderFooter ? '$header \n $data \n $footer' : data;

    var isInElectronJs = await _shouldPrintInElectron();
    if (isInElectronJs == true) {
      await _printInElectron(data, qr);
    } else {
      await _printUsingPrinterService(data);
    }
  }
  return "done printing";
}

Future _printUsingPrinterService(String data) async {
  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll57,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(children: [
            pw.Text(data, style: const pw.TextStyle(fontSize: 8))
          ]),
        ); // Center
      },
    ),
  ); // Page
  await Printing.layoutPdf(
    onLayout: (format) async => doc.save(),
  );
}

Future<bool> _shouldPrintInElectron() async {
  if (kIsWeb) {
    return JSHelper().callHasDirectPosPrinterAPI();
  } else {
    return false;
  }
}

Future<dynamic> _printInElectron(data, qr) async {
  if (kIsWeb) {
    return JSHelper().callDirectPosPrintAPI(data, qr);
  } else {
    throw {'message': 'not in web platform'};
  }
}
