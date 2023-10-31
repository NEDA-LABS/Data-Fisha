import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/util.dart';


prepareGetAllRemotePurchases(String startAt) {
  return composeAsync([
    itOrEmptyArray,
    (app) => httpGetRequest(
        '${shopFunctionsURL(app)}/stock/purchase?size=20&start=$startAt}'),
    shopToApp,
  ]);
}

preparePatchPurchasePayment(String? id, Map payment) {
  var patchInvoice = prepareHttpPatchRequest(payment);
  f(app) => patchInvoice('${shopFunctionsURL(app)}/stock/purchase/$id');
  return composeAsync([f, shopToApp]);
}

prepareCreatePurchase(Map purchase) {
  var createRequest = prepareHttpPutRequest(purchase);
  f(app) => createRequest('${shopFunctionsURL(app)}/stock/purchase');
  return composeAsync([f, shopToApp]);
}
