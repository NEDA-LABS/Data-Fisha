import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _shopTable = 'shop';
const _activeShopId = 'active';
const _shopId = 'shop_id';

Future saveShopId(String id) async {
  var save = CacheFactory().prepareSetData(smartstockApp, _shopTable);
  return save(_shopId, id);
}

Future saveActiveShop(shop) async {
  var save = CacheFactory().prepareSetData(smartstockApp, _shopTable);
  return save(_activeShopId, shop);
}

Future removeActiveShop() async {
  var rm = CacheFactory().prepareRemoveData(smartstockApp, _shopTable);
  return rm(_activeShopId);
}

Future getActiveShop() async {
  var getData = CacheFactory().prepareGetData(smartstockApp, _shopTable);
  return getData(_activeShopId);
}
