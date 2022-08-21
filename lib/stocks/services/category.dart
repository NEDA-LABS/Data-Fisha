import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/stocks/services/api_categories.dart';
import 'package:smartstock_pos/stocks/services/category_cache.dart';

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
      rCategories = await compute(_sort,rCategories);
      await saveLocalCategories(shopToApp(shop), rCategories);
      return rCategories;
    },
    (x) => compute(_sort,x as List),
  );
  return getItOrRemoteAndSave(categories);
}

Future<List> _sort(List data)async{
  data.sort((a, b) => '${a['name']}'.compareTo('${b['name']}'));
  return data;
}