import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/configs.dart';

const _shopTable = 'shop';
const _activeShopId = 'active';
const _shopId = 'shop_id';

Future saveShopId(String? id) async {
  Future<dynamic> Function(String, dynamic) save = CacheFactory().prepareSetData(smartStockApp, _shopTable);
  return save(_shopId, id);
}

Future saveActiveShop(shop) async {
  Future<dynamic> Function(String, dynamic) save = CacheFactory().prepareSetData(smartStockApp, _shopTable);
  return save(_activeShopId, shop);
}

Future removeActiveShop() async {
  var rm = CacheFactory().prepareRemoveData(smartStockApp, _shopTable);
  return rm(_activeShopId);
}

Future getActiveShop() async {
  var getData = CacheFactory().prepareGetData(smartStockApp, _shopTable);
  return getData(_activeShopId);
}
