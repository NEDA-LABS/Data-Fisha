import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_preparePatchRequest(body) => composeAsync([
      (x) => RawResponse(body: x.body, statusCode: x.statusCode),
      (url) => patch(Uri.parse(url),
          headers: getInitialHeaders(), body: jsonEncode(body))
    ]);

_prepareDeleteRequest() => composeAsync([
      (x) => RawResponse(body: x.body, statusCode: x.statusCode),
      (url) => delete(Uri.parse(url))
    ]);

_preparePutRequest(body) => composeAsync([
      (x) => RawResponse(body: x.body, statusCode: x.statusCode),
      (url) => put(Uri.parse(url),
          headers: getInitialHeaders(), body: jsonEncode(body))
    ]);

prepareCreateProduct(Map product) {
  var putRequest = _preparePutRequest(product);
  return composeAsync([
    (app) => executeHttp(
        () => putRequest('${shopFunctionsURL(app)}/stock/products')),
    shopToApp
  ]);
}

prepareOffsetProductQuantity(Map body) {
  var patchRequest = _preparePatchRequest(body);
  return composeAsync([
    (app) => executeHttp(() => patchRequest(
        '${shopFunctionsURL(app)}/stock/products/${body['id']}/quantity')),
    shopToApp
  ]);
}

prepareUpdateProductDetails(Map body) {
  var patchRequest = _preparePatchRequest(body);
  return composeAsync([
        (app) => executeHttp(() => patchRequest(
        '${shopFunctionsURL(app)}/stock/products/${body['id']}/detail')),
    shopToApp
  ]);
}

prepareDeleteProduct(String id) {
  var deleteRequest = _prepareDeleteRequest();
  return composeAsync([
    (app) => executeHttp(
        () => deleteRequest('${shopFunctionsURL(app)}/stock/products/$id')),
    shopToApp
  ]);
}
