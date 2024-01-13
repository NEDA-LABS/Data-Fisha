import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';

Future productCreateRestAPI(
    {required Map product, required dynamic shop}) async {
  if (kDebugMode) {
    print(product);
  }
  // throw Exception('F**k on');
  var putRequest = prepareHttpPutRequest(product);
  return putRequest('${shopFunctionsURL(shopToApp(shop))}/stock/products');
}

productOffsetQuantityRestAPI({required Map body, required Map shop}) {
  var patchRequest = prepareHttpPatchRequest(body);
  var url =
      '${shopFunctionsURL(shopToApp(shop))}/stock/products/${body['id']}/quantity';
  return patchRequest(url);
}

productUpdateDetailsRestAPI({required Map product, required Map shop}) {
  var patchRequest = prepareHttpPatchRequest(product);
  var url =
      '${shopFunctionsURL(shopToApp(shop))}/stock/products/${product['id']}/detail';
  return patchRequest(url);
}

productDeleteRestAPI({required String? id, required Map shop}) {
  var deleteRequest = prepareHttpDeleteRequest({});
  var url = '${shopFunctionsURL(shopToApp(shop))}/stock/products/$id';
  return deleteRequest(url);
}

productMovementRestAPI({required String id, required Map shop}) {
  var getRequest = prepareHttpGetRequest();
  var from = '2022-08-01';
  var to = toSqlDate(DateTime.now());
  var url =
      '${shopFunctionsURL(shopToApp(shop))}/stock/products/$id/quantity?from=$from&to=$to';
  return getRequest(url);
}
