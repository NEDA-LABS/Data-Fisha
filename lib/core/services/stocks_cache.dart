import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/configurations.dart';

const _stocksTable = 'stocks';
const _stocksId = 'stocks';

Future getLocalStocks() =>
    CacheFactory().get(smartstockApp, _stocksTable)(_stocksId);

saveLocalStocks(stocks) =>
    CacheFactory().set(smartstockApp, _stocksTable)(_stocksId, stocks);
