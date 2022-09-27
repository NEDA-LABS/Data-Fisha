import 'dart:convert';

import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart' as http;
import 'package:smartstock/core/services/util.dart';

_loginHttp(String username, String password) async {
  var a = await http.post(
    Uri.parse('$baseUrl/account/login'),
    headers: getInitialHeaders(),
    body: jsonEncode({"username": username, "password": password}),
  );
  return RawResponse(body: a.body, statusCode: a.statusCode);
}

_registerHttp(data) async {
  var a = await http.post(
    Uri.parse('$baseUrl/account/register'),
    headers: getInitialHeaders(),
    body: jsonEncode(data is Map ? data : {}),
  );
  return RawResponse(body: a.body, statusCode: a.statusCode);
}

var _getError = (x) => x['errors']['message'];

var _dataOrError = ifDoElse(
  (f) => f is Map && f['errors'] != null,
  (x) => throw _getError(x),
  (x) => x,
);

Future accountRemoteLogin(String u, String p) async {
  var getUser = composeAsync([_dataOrError, executeRule]);
  return getUser(() => _loginHttp(u, p));
}

Future accountRemoteRegister(data) async {
  var getUser = composeAsync([_dataOrError, executeRule]);
  return getUser(() => _registerHttp(data));
}
