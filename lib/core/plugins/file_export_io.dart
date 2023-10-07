import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadExportFile({
  required dynamic data,
  required String fileName,
  required String mime,
}) async {
  var platform = const MethodChannel('smartstock/channel');
  platform.invokeListMethod('file_export', {
    "data": _sendCorrectBytes(data),
    "filename": fileName,
    "mime": mime,
  }).then((value) {
    if (kDebugMode) {
      print(value);
    }
  }).catchError((reason) {
    if (kDebugMode) {
      print(reason);
    }
  });
}

_checkStoragePermission()async{
  var status = await Permission.storage.status;
  if (status.isDenied) {
    // We didn't ask for permission yet or the permission has been denied before, but not permanently.
  }
}

Uint8List _sendCorrectBytes(data) {
  if (data is String) {
    return Uint8List.fromList(data.codeUnits);
  } else if (data is List<int>) {
    return Uint8List.fromList(data);
  } else if (data is Uint8List) {
    return data;
  } else {
    return Uint8List(0);
  }
}
