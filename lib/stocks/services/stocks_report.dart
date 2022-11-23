import 'package:bfast/controller/function.dart';
import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

_getItemsRequest(App app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/stock/value/items');

_getItemsValueRequest(App app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/stock/value/purchase');

_getItemsRetailValueRequest(App app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/stock/value/retail');

_getItemsWholesaleRequest(App app) =>
    () => httpGetRequest('${shopFunctionsURL(app)}/stock/value/whole');

_getShop(x) => getActiveShop();

_total(x) => x['total'];

Future getTotalPositiveItems() {
  request(app) => executeHttp(_getItemsRequest(app));
  var positiveItems = composeAsync([_total, request, shopToApp, _getShop]);
  return positiveItems('');
}

Future getItemsValue() {
  request(app) => executeHttp(_getItemsValueRequest(app));
  var itemsValue = composeAsync([_total, request, shopToApp, _getShop]);
  return itemsValue('');
}

Future getItemsRetailValue() {
  request(app) => executeHttp(_getItemsRetailValueRequest(app));
  var retailValue = composeAsync([_total, request, shopToApp, _getShop]);
  return retailValue('');
}

Future getItemsWholesaleValue() {
  request(app) => executeHttp(_getItemsWholesaleRequest(app));
  var itemsWhole = composeAsync([_total, request, shopToApp, _getShop]);
  return itemsWhole('');
}
