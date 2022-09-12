import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_items.dart';

import 'item_cache.dart';

Future<List<dynamic>> getItemFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var items = skipLocal ? [] : await getLocalItems(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rItems = await getAllRemoteItems(shop);
      rItems = await compute(_filterAndSort,{"items": rItems, "query": stringLike});
      await saveLocalItems(shopToApp(shop), rItems);
      return rItems;
    },
    (x) => compute(_filterAndSort,{"items": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(items);
}

Future<List> _filterAndSort(Map data) async {
  var items = data['items'];
  String stringLike = data['query']??'';
  _where(x) =>
      x['brand'] != null &&
          '${x['brand']}'.toLowerCase().contains(stringLike.toLowerCase());

  items = items.where(_where).toList();
  items.sort((a, b) => '${a['brand']}'.toLowerCase().compareTo('${b['brand']}'.toLowerCase()));
  return items;
}
