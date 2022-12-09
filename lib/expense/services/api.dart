import 'package:bfast/controller/function.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

/// prepare get expenses from cloud.
/// [String start, String size, String query] => [Map shop] => List
prepareGetExpensesRemote(startAt, size, query) {
  getHttpReqFn(app) => () => httpGetRequest(
      '${shopFunctionsURL(app)}/expense?size=$size&start=$startAt&q=$query');
  return composeAsync([itOrEmptyArray, executeHttp, getHttpReqFn, shopToApp]);
}

/// prepare create expense to cloud. [List items] => [Map shop] => *
prepareCreateExpensesRemote(Map items) {
  var httpPutRequest = prepareHttpPutRequest(items);
  putHttpRequestFn(app) =>
      () => httpPutRequest('${shopFunctionsURL(app)}/expense');
  return composeAsync([executeHttp, putHttpRequestFn, shopToApp]);
}
