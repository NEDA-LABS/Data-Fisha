import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smartstock/core/helpers/functional.dart';

Map<String, String> _getInitialHeaders() =>
    <String, String>{'Content-Type': 'application/json'};

_parse(http.Response response) {
  if ('${response.statusCode}'.startsWith('2')) {
    var data = response.body;
    return jsonDecode(data);
  } else {
    var data = response.body;
    throw (data.startsWith('{') || data.startsWith('['))
        ? jsonDecode(response.body)
        : response.body;
  }
}

Future<dynamic> Function(String url) prepareHttpDeleteRequest(body,
    [Map<String, dynamic> headers = const {}]) {
  Future<http.Response> makeRequest(String url) {
    return http.delete(
      Uri.parse(url),
      headers: {..._getInitialHeaders(), ...headers},
      body: jsonEncode(body),
    );
  }

  return composeAsync([_parse, makeRequest]);
}

Future<dynamic> Function(String url) prepareHttpPutRequest(body,
    [Map<String, dynamic> headers = const {}]) {
  Future<http.Response> makeRequest(String url) {
    return http.put(
      Uri.parse(url),
      headers: {..._getInitialHeaders(), ...headers},
      body: jsonEncode(body),
    );
  }

  return composeAsync([_parse, makeRequest]);
}

Future<dynamic> Function(String url) prepareHttpPostRequest(body,
    [Map<String, dynamic> headers = const {}]) {
  Future<http.Response> makeRequest(String url) {
    return http.post(
      Uri.parse(url),
      headers: {..._getInitialHeaders(), ...headers},
      body: jsonEncode(body),
    );
  }

  return composeAsync([_parse, makeRequest]);
}

Future<dynamic> Function(String url) prepareHttpPatchRequest(body,
    [Map<String, dynamic> headers = const {}]) {
  Future<http.Response> makeRequest(String url) {
    return http.patch(
      Uri.parse(url),
      headers: {..._getInitialHeaders(), ...headers},
      body: jsonEncode(body),
    );
  }

  return composeAsync([_parse, makeRequest]);
}

httpGetRequest(String url, [Map<String, dynamic> headers = const {}]) {
  Future<http.Response> makeRequest(String url) {
    return http.get(
      Uri.parse(url),
      headers: {..._getInitialHeaders(), ...headers},
    );
  }

  return composeAsync([_parse, makeRequest])(url);
}
