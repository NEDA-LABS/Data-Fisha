import 'package:bfast/util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  String data ='',
  String qr = '',
  appendHeaderFooter = true,
}) async {
  // print(data);
  var currentShop = await getActiveShop();
  if (_getMustPrint(currentShop) == false) {
    var header = _getPrinterHeader(currentShop);
    var footer = _getPrinterFooter(currentShop);
    data = appendHeaderFooter ? '$header \n $data \n $footer' : data;

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello World'),
          ); // Center
        },
      ),
    ); // Page
    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
// await Future.delayed(const Duration(seconds: 3));
    // return await const MethodChannel('com.smartstock/printer').invokeMethod(
    //     'print', {"data": data, "printer": 'printer', "id": 'id', "qr": ''});
  }
  return "done printing";
}
