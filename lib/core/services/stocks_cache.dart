import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock_pos/core/services/cache_factory.dart';
import 'package:smartstock_pos/core/services/util.dart';

const _stocksTable = 'stocks';
const _stocksId = 'stocks';

Future getLocalStocks(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().get(app, _stocksTable),
    ])(_stocksId);

Future saveLocalStocks(App app, stocks) =>
    CacheFactory().set(app, _stocksTable)(_stocksId, itOrEmptyArray(stocks));
