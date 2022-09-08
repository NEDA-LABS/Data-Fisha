import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/api_stocks.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_stocks.dart';
import 'package:smartstock/core/services/util.dart';


Future<List<dynamic>> getStockFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var stocks = skipLocal ? [] : await getLocalStocks(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rStocks = await getAllRemoteStocks(shop);
      rStocks = await compute(
          _pruneAndSortStocks, {'stocks': rStocks, 'query': stringLike});
      await saveLocalStocks(shopToApp(shop),rStocks);
      return rStocks;
    },
    (x) => compute(_pruneAndSortStocks, {'stocks': x, 'query': stringLike}),
  );
  return getItOrRemoteAndSave(stocks);
}

Future<List> _pruneAndSortStocks(Map data) async {
  var stocks = data['stocks'];
  String stringLike = data['query'];
  _where(x) =>
      x['product'] != null &&
      '$x'.toLowerCase().contains(stringLike.toLowerCase());
  _map(x) {
    x['quantity'] = getStockQuantity(stock: x);
    return x;
  }

  stocks = stocks.where(_where).map(_map).toList();
  stocks.sort((a, b) => '${a['product']}'.toLowerCase().compareTo('${b['product']}'.toLowerCase()));
  return stocks;
}
