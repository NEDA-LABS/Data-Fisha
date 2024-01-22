import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';

Future productsPurchaseGetManyRestAPI({
  required String startAt,
  required Map shop,
  required String filterBy,
  required String filterValue,
}) async {
  var query =
      '?size=20&start=$startAt&filterBy=$filterBy&filterValue=$filterValue';
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase$query';
  var httpGetRequest = prepareHttpGetRequest();
  var purchases = await httpGetRequest(url);
  return itOrEmptyArray(purchases);
}

Future productsPurchaseDeleteRestAPI(String id, shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id';
  var deletePurchase = prepareHttpDeleteRequest({});
  return deletePurchase(url);
}

Future productsPurchasePaymentAddRestAPI(String id, Map payment, shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/payment';
  var patchPurchase = prepareHttpPatchRequest(payment);
  return patchPurchase(url);
}

Future productsPurchaseMetadataUpdateRestAPI(String id, Map metadata, shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/metadata';
  var patchPurchase = prepareHttpPatchRequest(metadata);
  return patchPurchase(url);
}

Future productsPurchaseAttachmentsUpdateRestAPI(String id, List<String> attachments, shop)async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/attachment';
  var patchPurchase = prepareHttpPatchRequest(attachments);
  return patchPurchase(url);
}

Future productsPurchaseCreateRestAPI(Map purchase, shop)async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase';
  var createPurchase = prepareHttpPutRequest(purchase);
  return createPurchase(url);
}
