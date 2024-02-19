import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/expense/services/api_categories.dart';
import 'package:smartstock/expense/services/cache_categories.dart';

Future<List<dynamic>> getExpenseCategoriesFromCacheOrRemote(
    [skipLocal = false, stringLike = '']) async {
  var shop = await getActiveShop();
  var categories =
      skipLocal ? [] : await getLocalExpenseCategories(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List r = await getExpenseCategoriesAPI(shop);
      r = await compute(_filterAndSort, {"items": r, "query": ''});
      await saveLocalExpenseCategories(shopToApp(shop), r);
      return r;
    },
    (x) => compute(_filterAndSort, {"items": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(categories);
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

Future createExpenseCategory(String name) async {
  var shop = await getActiveShop();
  var createCategory = prepareCreateExpenseCategoryAPI({"name": name});
  return createCategory(shop);
}
