import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/stocks/services/api_categories.dart';
import 'package:smartstock/stocks/services/category_cache.dart';

import '../../core/services/cache_shop.dart';
import '../../core/services/util.dart';

Future<List<dynamic>> getCategoryFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var categories = skipLocal ? [] : await getLocalCategories(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rCategories = await getAllRemoteCategories(shop);
      rCategories = await compute(
          _filterAndSort, {"categories": rCategories, "query": stringLike});
      await saveLocalCategories(shopToApp(shop), rCategories);
      return rCategories;
    },
    (x) => compute(_filterAndSort, {"categories": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(categories);
}

Future<List> _filterAndSort(Map data) async {
  var categories = data['categories'];
  String stringLike = data['query'];
  _where(x) =>
      x['name'] != null &&
      '${x['name']}'.toLowerCase().contains(stringLike.toLowerCase());

  categories = categories.where(_where).toList();
  categories.sort((a, b) =>
      '${a['name']}'.toLowerCase().compareTo('${b['name']}'.toLowerCase()));
  return categories;
}
