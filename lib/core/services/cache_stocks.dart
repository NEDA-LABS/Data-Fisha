import 'package:bfast/options.dart';
import 'package:bfast/util.dart';
import 'package:smartstock/core/services/cache_factory.dart';
import 'package:smartstock/core/services/util.dart';

const _stocksTable = 'stocks';
const _stocksId = 'stocks';

Future getLocalStocks(App app) => composeAsync([
      itOrEmptyArray,
      CacheFactory().prepareGetData(app, _stocksTable),
    ])(_stocksId);

Future saveLocalStocks(App app, stocks) =>
    CacheFactory().prepareSetData(app, _stocksTable)(_stocksId, itOrEmptyArray(stocks));
