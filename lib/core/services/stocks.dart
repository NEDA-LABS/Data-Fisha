import 'package:smartstock_pos/core/services/api_stocks.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';

import 'stocks_cache.dart';

Future<List<dynamic>> getStockFromCacheOrRemote() async {
    var shop = await getActiveShop();
    var stocks = await getLocalStocks();
    stocks ??= await getAllRemoteStocks(shop);
    stocks is List && stocks.isEmpty ? await getAllRemoteStocks(shop): stocks;
    return stocks;
}