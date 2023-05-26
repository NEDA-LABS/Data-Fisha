import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/configs.dart';

const _salesTable = 'sales';

Future<dynamic> saveSalesLocal(List batch) async {
  Future<dynamic> Function(String, dynamic) setData = CacheFactory().prepareSetData(smartStockApp, _salesTable);
  return setData(generateUUID(), batch);
}

Future getLocalSalesKeys() => CacheFactory().keys(smartStockApp, _salesTable);

Future getLocalSales(String key) =>
    CacheFactory().prepareGetData(smartStockApp, _salesTable)(key);

Future removeLocalSales(String key) =>
    CacheFactory().prepareRemoveData(smartStockApp, _salesTable)(key);

