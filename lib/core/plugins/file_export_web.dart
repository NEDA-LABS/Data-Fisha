import 'dart:html' as webFile;

Future<void> downloadExportFile({
  required dynamic data,
  required String fileName,
  required String mime,
}) async {
  var blob = webFile.Blob([data], mime, 'native');
  webFile.AnchorElement(
    href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
  )
    ..setAttribute("download", fileName)
    ..click();
}
