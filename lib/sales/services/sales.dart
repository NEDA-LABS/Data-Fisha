import 'dart:convert';

import 'package:bfast/controller/database.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';
import 'package:smartstock_pos/sales/services/sales_cache.dart';

import '../../core/services/security.dart';
import '../../core/services/util.dart';

Future saveSales(List sales, String cartId) async {
  List batchs = [];
  for (var sale in sales) {
    var batch = generateUUID();
    sale['cartId'] = cartId;
    sale['batch'] = batch;
    sale['id'] = batch;
    batchs.add(
        {"method": 'POST', "body": jsonEncode(sale), "path": '/classes/sales'});
  }
  return saveSalesLocal(batchs);
}

_allRemoteProductsHttpRequest(app) => post(
      Uri.parse('${shopFunctionsURL(app)}/stock/products'),
      headers: getInitialHeaders(),
      body: jsonEncode({"hashes": []}),
    );

var _allRemoteProducts = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  _allRemoteProductsHttpRequest,
]);


var getAllRemoteStocks = composeAsync([
  (products) => itOrEmptyArray(products),
  (app) => executeRule(() => _allRemoteProducts(app)),
  map(shopToApp),
]);
