import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/sales/services/api_customer.dart';
import 'package:smartstock/sales/services/cache_customer.dart';

Future<List<dynamic>> getCustomerFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var customers = skipLocal ? [] : await getLocalCustomers(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rCustomers = await salesCustomersRestAPI(shop);
      rCustomers = await compute(
          _filterAndSort, {"customers": rCustomers, "query": stringLike});
      saveLocalCustomers(shopToApp(shop), rCustomers).catchError((e) {});
      return rCustomers;
    },
    (x) => compute(_filterAndSort, {"customers": x, "query": stringLike}),
  );
  return getItOrRemoteAndSave(customers);
}

Future<List> _filterAndSort(Map data) async {
  var customers = data['customers'];
  String? stringLike = data['query'];
  _where(x) =>
      '${x['displayName']}'.toLowerCase().contains(stringLike!.toLowerCase());

  customers = customers.where(_where).toList();
  customers.sort((a, b) => '${a['displayName']}'
      .toLowerCase()
      .compareTo('${b['displayName']}'.toLowerCase()));
  return customers;
}
