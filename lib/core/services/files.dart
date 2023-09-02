import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:smartstock/core/services/cache_shop.dart';

String _web3Token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEI5YTAxYTI1MjE2MTJkMjY2NDQ4NDMyMjlGMzk2QzljNzU0N0IyY0IiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2OTM2NDg4Mjc4MzYsIm5hbWUiOiJzbWFydHN0b2NrLW1vYmlsZSJ9.mBzUijlLENpNUVZWAf5rvXAKr29NDWZaY78fi53SUSk';

Future<Map?> uploadFileToWeb3(PlatformFile? file) async {
  if (file == null) {
    if (kDebugMode) {
      print('File is empty');
    }
    return null;
  }
  // final file = result.files.first;
  String? filePath;
  try {
    filePath = file.path;
  } catch (e) {
    //
  }
  final filename = file.name;
  final fileSize = file.size;
  final mimeType = filePath != null
      ? lookupMimeType(filePath)
      : _getMimeType(file.extension ?? '');
  if (kDebugMode) {
    print(mimeType);
  }
  final contentType = mimeType != null ? MediaType.parse(mimeType) : null;

  final fileReadStream = file.readStream;
  if (fileReadStream == null) {
    throw Exception('Cannot read file from null stream');
  }
  final stream = http.ByteStream(fileReadStream);

  var shop = await getActiveShop();
  // '${shopFunctionsURL(shopToApp(shop))}/files'
  final uri = Uri.parse(
    'https://api.web3.storage/upload',
  );
  final request = http.MultipartRequest('POST', uri);
  final multipartFile = http.MultipartFile(
    'file',
    stream,
    fileSize,
    filename: filename,
    contentType: contentType,
  );
  request.files.add(multipartFile);
  request.headers.addAll({'Authorization': 'Bearer $_web3Token'});

  final httpClient = http.Client();
  final response = await httpClient.send(request);

  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }

  final body = await response.stream.transform(utf8.decoder).join();
  return {
    ...jsonDecode(body),
    "mime": mimeType,
    "name": filename,
    "size": fileSize
  };
}

String _getMimeType(String fileExtension) {
  switch (fileExtension.toLowerCase()) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'pdf':
      return 'application/pdf';
    case 'txt':
    case 'csv':
    case 'rsv':
      return 'text/plain';
    case 'html':
      return 'text/html';
    case 'css':
      return 'text/css';
    case 'js':
      return 'application/javascript';
    case 'json':
      return 'application/json';
    case 'xml':
      return 'application/xml';
    case 'mp3':
      return 'audio/mpeg';
    case 'mp4':
      return 'video/mp4';
    case 'wav':
      return 'audio/wav';
    case 'xls':
      return 'application/vnd.ms-excel';
    case 'xlsx':
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return 'application/octet-stream'; // Default MIME type for unknown extensions.
  }
}
