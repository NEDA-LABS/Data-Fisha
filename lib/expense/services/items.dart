import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/services/api_items.dart';
import 'package:smartstock/expense/services/cache_items.dart';

Future<List<dynamic>> getExpenseItemFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var items = skipLocal ? [] : await getLocalExpenseItems(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rItems = await getRemoteExpenseItemsAPI(shop);
      rItems = await compute(_filterAndSort, {"items": rItems, "query": ''});
      await saveLocalExpenseItems(shopToApp(shop), rItems);
      return rItems;
    },
    (x) => compute(_filterAndSort, {"items": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(items);
}

Future<List> _filterAndSort(Map data) async {
  var items = data['items'];
  String stringLike = data['query'] ?? '';
  whereFn(x) =>
      x['name'] != null &&
      '${x['name']}'.toLowerCase().contains(stringLike.toLowerCase());
  items = items.where(whereFn).toList();
  items.sort((a, b) =>
      '${a['name']}'.toLowerCase().compareTo('${b['name']}'.toLowerCase()));
  return items;
}

Future createExpenseItem(String name, String category) async {
  var shop = await getActiveShop();
  var createItem =
      prepareCreateExpenseItemAPI({"name": name, "category": category});
  return createItem(shop);
}
