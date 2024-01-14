import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future accountRemoteLogin(String u, String p) async {
  var httpPostRequest = prepareHttpPostRequest({'username': u, 'password': p});
  return httpPostRequest('$baseUrl/account/login');
}

Future accountRemoteRegister(data) async {
  var httpPostRequest = prepareHttpPostRequest(data);
  return httpPostRequest('$baseUrl/account/register');
}

Future accountRemoteReset(username) async {
  var httpGetRequest = prepareHttpGetRequest();
  return httpGetRequest('$baseUrl/account/reset?username=$username');
}
