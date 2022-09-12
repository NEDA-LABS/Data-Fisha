import 'dart:convert';

import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart' as http;

_loginHttp(String username, String password) async {
  var a = await http.post(
    Uri.parse('https://smartstock-daas.bfast.fahamutech.com/v2'),
    headers: getInitialHeaders(),
    body: jsonEncode({
      "applicationId": 'smartstock_lb',
      "auth": {
        "signIn": {"username": username, "password": password}
      }
    }),
  );
  return RawResponse(body: a.body, statusCode: a.statusCode);
}

var _userResponseHasAuth = ifThrow(
  (x) => x is! Map && x['auth'] == null,
  (x) => '$x',
);
var _userAuthHasSignIn = ifThrow(
  (x) => x['auth']['signIn'] == null,
  (x) => '$x',
);
var _extractUser = compose(
  [(x) => x['auth']['signIn'], _userAuthHasSignIn, _userResponseHasAuth],
);
var _getAuthErrors = map((x) => x['errors']['auth.signIn']['message']);

var _loginUserOrError = ifDoElse(
  (f) => f is Map && f['errors'] != null && f['errors']['auth.signIn'] != null,
  (x) => throw _getAuthErrors(x),
  (x) => _extractUser(x),
);

Future accountRemoteLogin(String u, String p) async {
  var getUser = composeAsync([_loginUserOrError, executeRule]);
  return getUser(() => _loginHttp(u, p));
}
