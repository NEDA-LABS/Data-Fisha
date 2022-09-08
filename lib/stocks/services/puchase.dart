import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/cart.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';

Future<List<dynamic>> getPurchaseFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  // var purchases = [];
  //skipLocal ? [] : await getLocalPurchases(shopToApp(shop));
  // var getItOrRemoteAndSave = ifDoElse(
  //   (x) => x == null || (x is List && x.isEmpty),
  //   inv(_) async {
  List rPurchases = await getAllRemotePurchases(stringLike)(shop);
  rPurchases = await compute(
      _filterAndSort, {"purchases": rPurchases, "query": stringLike});
  // await saveLocalPurchases(shopToApp(shop), rPurchases);
  return rPurchases;
  // }
  // ,
  // (x) => compute(_filterAndSort, {"purchases": x, "query": stringLike}),
  // );
  // return inv(purchases);
}

Future<List> _filterAndSort(Map data) async {
  var purchases = data['purchases'];
  // String stringLike = data['query'];
  // _where(x) =>
  //     '${x['displayName']}'.toLowerCase().contains(stringLike.toLowerCase());

  // purchases = purchases.where(_where).toList();
  // purchases.sort((a, b) =>
  //     '${a['date']}'.toLowerCase().compareTo('${b['date']}'.toLowerCase()));
  return purchases;
}

// Future _printPurchaseItems(
//     List carts, discount, customer, wholesale, batchId) async {
//   var items = cartItems(carts, discount, wholesale, '$customer');
//   var data = await cartItemsToPrinterData(items, '$customer', wholesale);
//   await posPrint(data: data, qr: batchId);
// }

Future<Map> _carts2Purchase(
    List carts, supplier, cartId, batchId, isCash) async {
  var totalAmount = int.tryParse('${cartTotalAmount(carts, false)}') ?? 0;
  String date = toSqlDate(DateTime.now());
  String due = toSqlDate(DateTime.now().add(const Duration(days: 14)));
  return {
    "date": "2022-09-01",
    "due": "2022-10-01",
    "refNumber": "abc",
    "batchId": batchId,
    "amount": totalAmount,
    "supplier": {"name": supplier},
    "user": {"username": "test"},
    "type": isCash ? "cash" : "credit",
    "items": carts.map((e) {
      return {
        "wholesalePrice": e.product['wholesalePrice'],
        "retailPrice": e.product['retailPrice'],
        "product": {
          "product": e.product['product'],
          "stockable": e.product['stockable'],
          "purchase": e.product['purchase'],
          "supplier": supplier
        },
        "amount": 0,
        "purchase": 0,
        "quantity": e.quantity
      };
    })
  };
}

Future onSubmitPurchase(List carts, String customer, discount) async {
  if (customer == null || customer.isEmpty) throw "Supplier required";
  String cartId = generateUUID();
  String batchId = generateUUID();
  var shop = await getActiveShop();
  var url = '${shopFunctionsURL(shopToApp(shop))}/purchase';
  // await _printPurchaseItems(carts, discount, customer, true, cartId);
  var purchase = await _carts2Purchase(carts, customer, cartId, batchId, true);
  print(purchase);
  // await saveLocalSync(batchId, url, purchase);
  // oneTimeLocalSyncs();
}
