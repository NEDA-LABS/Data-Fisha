import 'package:bfast/controller/function.dart';
import 'package:bfast/model/raw_response.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:http/http.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/util.dart';

var _getRequest = composeAsync([
  map((x) => RawResponse(body: x.body, statusCode: x.statusCode)),
  (path) => get(Uri.parse(path)),
]);

_getPositiveItemsRequest(App app) =>
    () => _getRequest('${shopFunctionsURL(app)}/stock/value/items');

_getItemsValueRequest(App app) =>
    () => _getRequest('${shopFunctionsURL(app)}/stock/value/purchase');

_getItemsRetailValueRequest(App app) =>
    () => _getRequest('${shopFunctionsURL(app)}/stock/value/retail');

_getItemsWholesaleRequest(App app) =>
    () => _getRequest('${shopFunctionsURL(app)}/stock/value/whole');

Future getTotalPositiveItems() => composeAsync([
      map((x) => x['total']),
      (app) => executeHttp(_getPositiveItemsRequest(app)),
      map(shopToApp),
      (x) => getActiveShop(),
    ])('');

Future getItemsValue() => composeAsync([
      map((x) => x['total']),
      (app) => executeHttp(_getItemsValueRequest(app)),
      map(shopToApp),
      (x) => getActiveShop(),
    ])('');

Future getItemsRetailValue() => composeAsync([
      map((x) => x['total']),
      (app) => executeHttp(_getItemsRetailValueRequest(app)),
      map(shopToApp),
      (x) => getActiveShop(),
    ])('');

Future getItemsWholesaleValue() => composeAsync([
      map((x) => x['total']),
      (app) => executeHttp(_getItemsWholesaleRequest(app)),
      map(shopToApp),
      (x) => getActiveShop(),
    ])('');
