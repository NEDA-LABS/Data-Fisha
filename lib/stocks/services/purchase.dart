import 'dart:async';

import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';

Future<List<dynamic>> productsGetPurchases(
    {String? startAt, String? filterBy, String? filterValue}) async {
  Map shop = await getActiveShop();
  var start = startAt ?? toSqlDate(DateTime.now());
  List<dynamic> purchases = await productsPurchaseGetManyRestAPI(
    startAt: start,
    shop: shop,
    filterBy: filterBy ?? 'ref_number',
    filterValue: filterValue ?? '',
  );
  return purchases;
}

Future productsPurchaseMetadataUpdate(
    {required String id, required Map metadata}) async {
  Map shop = await getActiveShop();
  var response =
      await productsPurchaseMetadataUpdateRestAPI(id, metadata, shop);
  return response;
}

Future productsPurchaseAttachmentsUpdate(
    {required String id, required List<String> files}) async {
  Map shop = await getActiveShop();
  var response =
      await productsPurchaseAttachmentsUpdateRestAPI(id, files, shop);
  return response;
}

Future productsPurchasePaymentAdd(
    {required String id, required Map payment}) async {
  Map shop = await getActiveShop();
  var response = await productsPurchasePaymentAddRestAPI(id, payment, shop);
  return response;
}

Future productsPurchaseDelete({required String id}) async {
  Map shop = await getActiveShop();
  var response = await productsPurchaseDeleteRestAPI(id, shop);
  return response;
}
