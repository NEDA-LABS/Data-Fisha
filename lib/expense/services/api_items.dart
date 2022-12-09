import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

_getHttpReqFn(app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/expense/items');

/// retrieve all cloud expense items. [Map shop] => List
var getRemoteExpenseItems =
    composeAsync([itOrEmptyArray, executeHttp, _getHttpReqFn, shopToApp]);

/// prepare create an expense item to cloud. [Map item] => [Map shop] => Map
prepareCreateExpenseItem(Map item) {
  var createRequest = prepareHttpPutRequest(item);
  appToHttpReqFn(app) =>
      () => createRequest('${shopFunctionsURL(app)}/expense/items');
  return composeAsync([executeHttp, appToHttpReqFn, shopToApp]);
}

/// prepare delete an expense item from cloud. [String id] => [Map shop] => *
prepareDeleteExpenseItem(String id) {
  var deleteRequest = prepareDeleteRequest({});
  appToHttpReqFn(app) =>
      () => deleteRequest('${shopFunctionsURL(app)}/expense/items/$id');
  return composeAsync([executeHttp, appToHttpReqFn, shopToApp]);
}
