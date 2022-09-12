import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';

_prepareCreateRequest(purchase) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      preparePutRequest(purchase)
    ]);

_preparePatchRequest(body) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      preparePatchRequest(body)
    ]);

var _getPurchases = composeAsync([
  (x) => RawResponse(body: x.body, statusCode: x.statusCode),
  getRequest,
]);

var getAllRemotePurchases = (String startAt) => composeAsync([
      (purchases) => itOrEmptyArray(purchases),
      (app) => executeHttp(() => _getPurchases(
          '${shopFunctionsURL(app)}/stock/purchase?skip=0&size=50')),
      map(shopToApp),
    ]);

preparePatchPurchasePayment(String? id, Map payment) {
  var patchInvoice = _preparePatchRequest(payment);
  f(app) => () => patchInvoice('${shopFunctionsURL(app)}/stock/purchase/$id');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}

prepareCreatePurchase(Map purchase) {
  var createRequest = _prepareCreateRequest(purchase);
  f(app) => () => createRequest('${shopFunctionsURL(app)}/stock/purchase');
  return composeAsync([(app) => executeHttp(f(app)), map(shopToApp)]);
}
