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

Future saveLocalStocks(App app, stocks) => CacheFactory()
    .prepareSetData(app, _stocksTable)(_stocksId, itOrEmptyArray(stocks));

Future deleteLocalStock(App app, id) async {
  var stocks = await getLocalStocks(app);
  var newStocks = stocks.where((e) {
    return id != e['id'];
  });
  await saveLocalStocks(app, newStocks);
}

Future saveLocalStock(App app, Map stock) async {
  var stocks = await getLocalStocks(app);
  var newStocks = stocks.map((e) {
    if (stock['id'] == e['id']) {
      return stock;
    }
    return e;
  });
  await saveLocalStocks(app, newStocks);
}
