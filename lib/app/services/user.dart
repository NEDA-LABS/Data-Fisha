import 'package:bfast/controller/database.dart';
import 'package:bfast/options.dart';
import 'package:http/http.dart' as http;

_loginHttp(App app, String username, String password) async {
  var url = databaseURL(app);
  return http.post(
    Uri.parse(url('')),
    headers: getInitialHeaders(),
    body: {
      "applicationId": app.applicationId,
      "auth": {
        "signIn": {"username": username, "password": password}
      }
    },
  );
}

Future Function(String u, String p) login(App app)  =>
    (String username, String password) async {
      var data = executeRule(_loginHttp(app, username, password));
      print(data);
    };
