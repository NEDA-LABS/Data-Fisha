import 'package:smartstock_pos/core/services/security.dart';
import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _salesTable = 'sales';

Future<dynamic> saveSalesLocal(List batch) async {
  var setData = CacheFactory().prepareSetData(smartstockApp, _salesTable);
  return setData(generateUUID(), batch);
}

Future getLocalSalesKeys() => CacheFactory().keys(smartstockApp, _salesTable);

Future getLocalSales(String key) =>
    CacheFactory().prepareGetData(smartstockApp, _salesTable)(key);

Future removeLocalSales(String key) =>
    CacheFactory().prepareRemoveData(smartstockApp, _salesTable)(key);

