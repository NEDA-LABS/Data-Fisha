import 'dart:convert';

import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart' as http;
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/util.dart';

_loginHttp(App app, String username, String password) async {
  var url = databaseURL(app);
  var a = await http.post(
    Uri.parse(url('')),
    headers: getInitialHeaders(),
    body: jsonEncode({
      "applicationId": app.applicationId,
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

Future Function(String u, String p) remoteLogin(App app) =>
    (String username, String password) async {
      var getUser = composeAsync([_loginUserOrError, executeRule]);
      // var user = await executeRule(() => _loginHttp(app, username, password));
      // print(user);
      // return _loginUserOrError(user);
      return getUser(() => _loginHttp(app, username, password));
    };

localLogOut() {
  removeActiveShop();
  removeLocalCurrentUser();
  navigateTo('/');
}
