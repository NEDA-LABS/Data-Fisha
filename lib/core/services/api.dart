import 'dart:convert';

import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

_parse(x){
  // print(x.statusCode);
  return RawResponse(body: x.body, statusCode: x.statusCode);
}

prepareDeleteRequest(body) {
  request(url) =>
      delete(Uri.parse(url), headers: getInitialHeaders(), body: jsonEncode(body));
  return composeAsync([_parse, request]);
}

preparePutRequest(body) {
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

var getRequest = composeAsync([_parse, (path) => get(Uri.parse(path))]);
