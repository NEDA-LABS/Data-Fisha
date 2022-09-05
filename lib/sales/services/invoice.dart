import 'package:flutter/foundation.dart';

import '../../core/services/cache_shop.dart';

// import '../../core/services/util.dart';
import 'api_invoice.dart';
// import 'customer_cache.dart';

Future<List<dynamic>> getInvoiceFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  var invoices = [];
  //skipLocal ? [] : await getLocalInvoices(shopToApp(shop));
  // var getItOrRemoteAndSave = ifDoElse(
  //   (x) => x == null || (x is List && x.isEmpty),
  //   inv(_) async {
  List rInvoices = await getAllRemoteInvoices(stringLike)(shop);
  rInvoices = await compute(
      _filterAndSort, {"invoices": rInvoices, "query": stringLike});
  // await saveLocalInvoices(shopToApp(shop), rInvoices);
  return rInvoices;
  // }
  // ,
  // (x) => compute(_filterAndSort, {"invoices": x, "query": stringLike}),
  // );
  // return inv(invoices);
}

Future<List> _filterAndSort(Map data) async {
  var invoices = data['invoices'];
  // String stringLike = data['query'];
  // _where(x) =>
  //     '${x['displayName']}'.toLowerCase().contains(stringLike.toLowerCase());

  // invoices = invoices.where(_where).toList();
  // invoices.sort((a, b) =>
  //     '${a['date']}'.toLowerCase().compareTo('${b['date']}'.toLowerCase()));
  return invoices;
}
