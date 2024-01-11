import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

ByteStream _getByteStream(List<int>? bytes) {
  // final file = result.files.first;
  // final fileReadStream = file.readStream;
  if (bytes == null) {
    throw Exception('Cannot read file from null stream');
  }
  return http.ByteStream.fromBytes(bytes);
}

MultipartFile _getMultipartFromStream(FileData file, ByteStream stream) {
  Map metadata = _getFileMetaData(file);
  MediaType? contentType = _getContentType(file);
  return http.MultipartFile(
    'file',
    stream,
    metadata['fileSize'],
    filename: metadata['filename'],
    contentType: contentType,
  );
}

Map<String, dynamic> _getFileMetaData(FileData file) {
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
  return {'filename': filename, 'fileSize': fileSize, 'mimeType': mimeType};
}

_getContentType(FileData file) {
  var metadata = _getFileMetaData(file);
  return metadata['mimeType'] != null
      ? MediaType.parse(metadata['mimeType'])
      : null;
}

Future<List<Map>> uploadFileToWeb3(List<FileData?> files) async {
  var shop = await getActiveShop();
  var base = shopFunctionsURL(shopToApp(shop));
  var url = '$base/storage';
  if (files.isEmpty) {
    if (kDebugMode) {
      print('Files empty');
    }
    return [];
  }

  final List<Map> metadatas = [];
  final uri = Uri.parse(url);
  final request = http.MultipartRequest('POST', uri);

  for (FileData? file in files) {
    if (file !=null) {
      ByteStream stream = _getByteStream(file.stream);
      Map metadata = _getFileMetaData(file);
      metadatas.add(metadata);
      MultipartFile multipartFile = _getMultipartFromStream(file, stream);
      request.files.add(multipartFile);
    }
  }

  request.headers.addAll({'Authorization': 'Bearer'});

  final httpClient = http.Client();
  final response = await httpClient.send(request);

  if (response.statusCode != 200) {
    throw Exception(response.reasonPhrase);
  }

  final body = await response.stream.transform(utf8.decoder).join();
  var bodyInJson = jsonDecode(body);
  var filePaths = propertyOr('urls', (p0) => [])(bodyInJson);

  return itOrEmptyArray(filePaths).map((filePath){


    if (kDebugMode) {
      print('----------------');
      print(filePath);
      print(metadatas);
      print('----------------');
    }


    var cid = '$filePath'
        .split('/')
        .where((element) => element.trim() != '')
        .toList()[1];
    var link = '$base$filePath';
    // print(filePath);
    // print(link);
    // throw Exception("just fail");
    return {
      "cid": cid,
      "link": link,
      // "mime": metadata['mimeType'],
      // "name": metadata['filename'],
      // "size": metadata['fileSize']
    };
  }).toList();
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
