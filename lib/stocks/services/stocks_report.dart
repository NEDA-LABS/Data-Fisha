import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/App.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/api_report.dart';

_getItemsRequest(App app) => httpGetRequest('${shopFunctionsURL(app)}/stock/value/items');

_getItemsValueRequest(App app) => httpGetRequest('${shopFunctionsURL(app)}/stock/value/purchase');

_getItemsRetailValueRequest(App app) => httpGetRequest('${shopFunctionsURL(app)}/stock/value/retail');

_getItemsWholesaleRequest(App app) => httpGetRequest('${shopFunctionsURL(app)}/stock/value/whole');

_getShop(x) => getActiveShop();

_total(x) => x['total'];

Future getTotalPositiveItems() {
  var positiveItems = composeAsync([_total, _getItemsRequest, shopToApp, _getShop]);
  return positiveItems('');
}

Future getItemsValue() {
  var itemsValue = composeAsync([_total, _getItemsValueRequest, shopToApp, _getShop]);
  return itemsValue('');
}

Future getItemsRetailValue() {
  var retailValue = composeAsync([_total, _getItemsRetailValueRequest, shopToApp, _getShop]);
  return retailValue('');
}

Future getItemsWholesaleValue() {
  var itemsWhole = composeAsync([_total, _getItemsWholesaleRequest, shopToApp, _getShop]);
  return itemsWhole('');
}

Future<Map> getStockIndexReport() async {
  var shop = await getActiveShop();
  var data = await requestStockReportSummary(shop);
  return data as Map;
}
