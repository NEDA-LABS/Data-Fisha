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

Future productsPurchasePaymentAddRestAPI(String id, Map payment, shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/payment';
  var patchInvoice = prepareHttpPatchRequest(payment);
  return patchInvoice(url);
}

Future productsPurchaseMetadataUpdateRestAPI(String id, Map metadata, shop) async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/metadata';
  var patchInvoice = prepareHttpPatchRequest(metadata);
  return patchInvoice(url);
}

Future productsPurchaseAttachmentsUpdateRestAPI(String id, List<String> attachments, shop)async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase/$id/attachment';
  var patchInvoice = prepareHttpPatchRequest(attachments);
  return patchInvoice(url);
}

Future productsPurchaseCreateRestAPI(Map purchase, shop)async {
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/purchase';
  var createRequest = prepareHttpPutRequest(purchase);
  return createRequest(url);
}
