import 'package:permission_handler/permission_handler.dart';

Future<void> downloadExportFile({
  required List<dynamic> data,
  required String fileName,
  required String mime,
}) async {
//   var status = await Permission.manageExternalStorage.status;
//   if (status.isDenied) {
//     // We didn't ask for permission yet or the permission has been denied before, but not permanently.
//   }
//
// // You can can also directly ask the permission about its status.
//   if (await Permission.location.isRestricted) {
//     // The OS restricts access, for example because of parental controls.
//   }
  // var blob = webFile.Blob(data, 'text/plain', 'native');
  // webFile.AnchorElement(
  //   href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
  // )
  //   ..setAttribute("download", fileName)
  //   ..click();
}
