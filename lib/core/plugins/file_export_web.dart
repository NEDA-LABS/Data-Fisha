import 'dart:html' as webFile;

Future<void> downloadExportFile({
  required List<dynamic> data,
  required String fileName,
  required String mime,
}) async {
  var blob = webFile.Blob(data, 'text/plain', 'native');
  webFile.AnchorElement(
    href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute("download", fileName)
    ..click();
}
