import 'package:bfast/options.dart';
import 'package:smartstock_pos/core/services/cache_factory.dart';

const _stocksTable = 'stocks';
const _stocksId = 'stocks';

Future getLocalStocks(App app) =>
    CacheFactory().get(app, _stocksTable)(_stocksId);

Future saveLocalStocks(App app, stocks) =>
    CacheFactory().set(app, _stocksTable)(_stocksId, stocks);
