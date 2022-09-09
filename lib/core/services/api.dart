import 'dart:convert';

import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

preparePutRequest(body) => (url) => put(
  Uri.parse(url),
  headers: getInitialHeaders(),
  body: jsonEncode(body),
);

preparePostRequest(body) => (url) => post(
  Uri.parse(url),
  headers: getInitialHeaders(),
  body: jsonEncode(body),
);

getRequest(url) => get(Uri.parse(url));

preparePatchRequest(body) => (url) => patch(
  Uri.parse(url),
  headers: getInitialHeaders(),
  body: jsonEncode(body),
);

var getHttpRequest = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  (path) => get(Uri.parse(path)),
]);
