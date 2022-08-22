import 'dart:convert';

import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';

import '../../core/services/util.dart';

_createProductHttpRequest(product) => (url) => put(
      Uri.parse(url),
      headers: getInitialHeaders(),
      body: jsonEncode(product),
    );

_createProduct(product) => composeAsync([
      map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
      _createProductHttpRequest(product)
    ]);

createProduct(Map product) {
  var createRequest = _createProduct(product);
  return composeAsync([
    (app) => executeHttp(
        () => createRequest('${shopFunctionsURL(app)}/stock/products')),
    map(shopToApp)
  ]);
}
