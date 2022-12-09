import 'dart:convert';

import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

_parse(x) => RawResponse(body: x.body, statusCode: x.statusCode);

/// prepare DELETE http request. [Map body] => [String url] => http_response
prepareDeleteRequest(body) {
  request(url) => delete(Uri.parse(url),
      headers: getInitialHeaders(), body: jsonEncode(body));
  return composeAsync([_parse, request]);
}

/// prepare PUT http request. [Map body] => [String url] => http_response
prepareHttpPutRequest(body) {
  request(url) =>
      put(Uri.parse(url), headers: getInitialHeaders(), body: jsonEncode(body));
  return composeAsync([_parse, request]);
}

preparePostRequest(body) {
  request(url) => post(Uri.parse(url),
      headers: getInitialHeaders(), body: jsonEncode(body));
  return composeAsync([_parse, request]);
}

preparePatchRequest(body) {
  request(url) => patch(Uri.parse(url),
      headers: getInitialHeaders(), body: jsonEncode(body));
  return composeAsync([_parse, request]);
}

/// perform GET http request to given path. [String path] => http_response
var httpGetRequest = composeAsync([_parse, get, Uri.parse]);
