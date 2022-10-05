import 'package:bfast/controller/function.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

Future updateUserDetailsRemote(user, data) async {
  var url = '$baseUrl/account/${user['id']}/details';
  var putRequest = preparePutRequest(data);
  return executeHttp(() => putRequest(url));
}

Future getShopUsersRemote(shop) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users';
  return executeHttp(() => getRequest(url));
}

Future addShopUserRemote(shop, data) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users';
  var postRequest = preparePostRequest(data);
  return executeHttp(() => postRequest(url));
}

Future updateShopUserPasswordRemote(shop, userId, password) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users/$userId';
  var putRequest = preparePutRequest({'password': password});
  return executeHttp(() => putRequest(url));
}

Future deleteShopUserRemote(shop, userId) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users/$userId';
  var deleteRequest = prepareDeleteRequest({});
  return executeHttp(() => deleteRequest(url));
}
