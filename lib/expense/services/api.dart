import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

Future Function(dynamic shop) prepareGetExpensesRemote(startAt, size, query) {
  getHttpReqFn(app) => httpGetRequest(
      '${shopFunctionsURL(app)}/expense?size=$size&start=$startAt&q=$query');
  return composeAsync([itOrEmptyArray, getHttpReqFn, shopToApp]);
}

Future Function(dynamic shop) prepareCreateExpensesRemote(Map items) {
  var httpPutRequest = prepareHttpPutRequest(items);
  putHttpRequestFn(app) => httpPutRequest('${shopFunctionsURL(app)}/expense');
  return composeAsync([putHttpRequestFn, shopToApp]);
}

Future Function(dynamic shop) prepareDeleteExpensesRemote(dynamic id) {
  var httpDeleteRequest = prepareHttpDeleteRequest({});
  deleteHttpRequestFn(app) =>
      httpDeleteRequest('${shopFunctionsURL(app)}/expense/$id');
  return composeAsync([deleteHttpRequestFn, shopToApp]);
}

Future Function(dynamic shop) prepareGetExpensesSummaryReport(date) {
  return composeAsync(
    [
      (app) => httpGetRequest(
          '${shopFunctionsURL(app)}/report/expenses/dashboard?from=$date&to=$date'),
      shopToApp,
    ],
  );
}
