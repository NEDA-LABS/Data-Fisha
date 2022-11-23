import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

_getHttpReqFn(app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/expense/categories');

/// retrieve all cloud expense categories. [Map shop] => List
var getRemoteExpenseCategories =
    composeAsync([itOrEmptyArray, executeHttp, _getHttpReqFn, shopToApp]);

/// prepare create an expense category to cloud. [Map item] => [Map shop] => Map
prepareCreateExpenseCategory(Map item) {
  var createRequest = prepareHttpPutRequest(item);
  appToHttpReqFn(app) =>
      () => createRequest('${shopFunctionsURL(app)}/expense/categories');
  return composeAsync([executeHttp, appToHttpReqFn, shopToApp]);
}

/// prepare delete an expense category from cloud. [String id] => [Map shop] => *
prepareDeleteExpenseCategory(String id) {
  var deleteRequest = prepareDeleteRequest({});
  appToHttpReqFn(app) =>
      () => deleteRequest('${shopFunctionsURL(app)}/expense/categories/$id');
  return composeAsync([executeHttp, appToHttpReqFn, shopToApp]);
}
