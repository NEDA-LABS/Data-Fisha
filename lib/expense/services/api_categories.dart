import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

_getHttpReqFn(app) =>
    httpGetRequest('${shopFunctionsURL(app)}/expense/categories');

Future  getExpenseCategoriesAPI(shop) {
  return composeAsync([itOrEmptyArray, _getHttpReqFn, shopToApp])(shop);
}

Future Function(dynamic shop) prepareCreateExpenseCategoryAPI(Map item) {
  var createRequest = prepareHttpPutRequest(item);
  appToHttpReqFn(app) =>
      createRequest('${shopFunctionsURL(app)}/expense/categories');
  return composeAsync([appToHttpReqFn, shopToApp]);
}

Future Function(dynamic shop) prepareDeleteExpenseCategoryAPI(String id) {
  var deleteRequest = prepareHttpDeleteRequest({});
  appToHttpReqFn(app) =>
      deleteRequest('${shopFunctionsURL(app)}/expense/categories/$id');
  return composeAsync([appToHttpReqFn, shopToApp]);
}
