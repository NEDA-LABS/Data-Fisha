import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/helpers/util.dart';

_getHttpReqFn(app) => httpGetRequest('${shopFunctionsURL(app)}/expense/items');

Future getRemoteExpenseItemsAPI(shop){
  return  composeAsync([itOrEmptyArray, _getHttpReqFn, shopToApp])(shop);
}

Future Function(dynamic shop) prepareCreateExpenseItemAPI(Map item) {
  var createRequest = prepareHttpPutRequest(item);
  appToHttpReqFn(app) => createRequest('${shopFunctionsURL(app)}/expense/items');
  return composeAsync([appToHttpReqFn, shopToApp]);
}

Future Function(dynamic shop) prepareDeleteExpenseItemAPI(String id) {
  var deleteRequest = prepareHttpDeleteRequest({});
  appToHttpReqFn(app) => deleteRequest('${shopFunctionsURL(app)}/expense/items/$id');
  return composeAsync([appToHttpReqFn, shopToApp]);
}
