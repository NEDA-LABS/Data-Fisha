import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_suppliers.dart';
import 'package:smartstock/stocks/services/supplier_cache.dart';

Future<List<dynamic>> getSupplierFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var suppliers = skipLocal ? [] : await getLocalSuppliers(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rSuppliers = await getAllRemoteSuppliers(shop);
      rSuppliers = await compute(
          _filterAndSort, {"suppliers": rSuppliers, "query": stringLike});
      await saveLocalSuppliers(shopToApp(shop), rSuppliers);
      return rSuppliers;
    },
    (x) => compute(_filterAndSort, {"suppliers": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(suppliers);
}

Future<List> _filterAndSort(Map data) async {
  var suppliers = data['suppliers'];
  String? stringLike = data['query'];
  _where(x) =>
      x['name'] != null &&
      '${x['name']}'.toLowerCase().contains(stringLike!.toLowerCase());

  suppliers = suppliers.where(_where).toList();
  suppliers.sort((a, b) =>
      '${a['name']}'.toLowerCase().compareTo('${b['name']}'.toLowerCase()));
  return suppliers;
}
