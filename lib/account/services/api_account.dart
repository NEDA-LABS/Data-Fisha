import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

Future updateUserDetailsRemote(user, data) async {
  var url = '$baseUrl/account/${user['id']}/details';
  var putRequest = prepareHttpPutRequest(data);
  return putRequest(url);
}

Future getShopUsersRemote(shop) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users';
  return httpGetRequest(url);
}

Future addShopUserRemote(shop, data) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users';
  var postRequest = prepareHttpPostRequest(data);
  return postRequest(url);
}

Future updateShopUserPasswordRemote(shop, userId, password) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users/$userId';
  var putRequest = prepareHttpPutRequest({'password': password});
  return putRequest(url);
}

Future deleteShopUserRemote(shop, userId) async {
  var getProjectId = propertyOr('projectId', (p0) => null);
  var url = '$baseUrl/account/shops/${getProjectId(shop)}/users/$userId';
  var deleteRequest = prepareHttpDeleteRequest({});
  return deleteRequest(url);
}
