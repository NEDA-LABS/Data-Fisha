import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/plugins/file_export.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

exportToCsv(String fileName, x) {
  List data = itOrEmptyArray(x);
  var csv = '';
  if (data.isNotEmpty) {
    var getHeader = ifDoElse((f) => f is Map, (x) => x, (_) => {});
    var title = getHeader(data[0]).keys.join(',');
    var body = data.map((e) => e.values.join(',')).join('\n');
    csv = '$title\n$body'.trim();
  }
  downloadExportFile(
      data: csv, fileName: '$fileName.csv', mime: 'text/plain');
}

exportToExcel(String filename, x) {
  List data = itOrEmptyArray(x);
  List<int> excel = [];
  if (data.isNotEmpty) {
    var getHeader = ifDoElse((f) => f is Map, (x) => x, (_) => {});
    List headersKey = getHeader(data[0]).keys.toList();
    final Workbook workbook = Workbook();
    var sheet = workbook.worksheets[0];
    for (var i = 1; i <= headersKey.length; i++) {
      sheet.getRangeByIndex(1, i).setValue(headersKey[i - 1]);
    }
    for (var r = 1; r <= data.length; r++) {
      for (var c = 1; c <= data[r - 1].values.toList().length; c++) {
        sheet
            .getRangeByIndex(r + 1, c)
            .setValue(data[r - 1].values.toList()[c - 1]);
      }
    }
    excel = workbook.saveAsStream();
    workbook.dispose();
  }
  downloadExportFile(
      data: excel, fileName: '$filename.xlsx', mime: 'application/xlsx');
}

exportPDF(String title, x) async {
  List data = itOrEmptyArray(x);
  final doc = pw.Document();
  if (data.isNotEmpty) {
    var getHeader = ifDoElse((f) => f is Map, (x) => x, (_) => {});
    var headers = getHeader(data[0])
        .keys
        .map<pw.Padding>((e) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Text('$e')))
        .toList();
    List<pw.TableRow> body = data.map<pw.TableRow>((e) {
      return pw.TableRow(
          children: e.values
              .map<pw.Padding>((x) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                  child: pw.Text('$x')))
              .toList());
    }).toList();

    for (var i = 0; i < body.length; i += 20) {
      dynamic table = pw.Container();
      table = pw.Table(
        children: [
          pw.TableRow(children: headers),
          ...body.sublist(i, i + 20 > body.length ? body.length : i + 20),
        ],
      );
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(children: [
                pw.Text(title, style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 20),
                table,
              ]),
            ); // Center
          },
        ),
        // index: a
      );
    }
  }

  // await Printing.layoutPdf(
  //   onLayout: (format) async => doc.save(),
  //   name: title,
  //   dynamicLayout: true,
  // );
  var pdfFile = await doc.save();
  downloadExportFile(
      data: pdfFile, fileName: '$title.pdf', mime: 'application/pdf');

}
