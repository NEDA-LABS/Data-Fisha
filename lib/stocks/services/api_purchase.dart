import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

productsGetPurchaseRestAPI(String startAt, shop) async {
  var url =
      '${shopFunctionsURL(shopToApp(shop))}/stock/purchase?size=20&start=$startAt}';
  var httpGetRequest = prepareHttpGetRequest();
  var purchases = await httpGetRequest(url);
  return itOrEmptyArray(purchases);
}

productsUpdatePurchasePaymentsRestAPI(String id, Map payment, shop) {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id';
  var patchInvoice = prepareHttpPatchRequest(payment);
  return patchInvoice(url);
}

productsCreatePurchaseRestAPI(Map purchase, shop) {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase';
  var createRequest = prepareHttpPutRequest(purchase);
  return createRequest(url);
}
