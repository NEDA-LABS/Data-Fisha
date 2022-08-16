import 'package:smartstock_pos/common/services/storage_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _shopTable = 'shop';

saveShopId(String id) async {
  var save = CacheFactory().set(smartstockApp, _shopTable);
  return save('shop_id', id);
}

saveActiveShop(shop) async {
  var save = CacheFactory().set(smartstockApp, _shopTable);
  return save('shop', shop);
}
