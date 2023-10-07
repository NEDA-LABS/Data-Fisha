import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
