import 'dart:async';

import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/add_purchase_detail.dart';
import 'package:smartstock/stocks/services/api_purchase.dart';

Future<List<dynamic>> getPurchasesRemote(startAt) async {
  var shop = await getActiveShop();
  // var purchases = [];
  //skipLocal ? [] : await getLocalPurchases(shopToApp(shop));
  // var getItOrRemoteAndSave = ifDoElse(
  //   (x) => x == null || (x is List && x.isEmpty),
  //   inv(_) async {
  var start = startAt ?? toSqlDate(DateTime.now());
  var remoteRequest = prepareGetAllRemotePurchases(start);
  List purchases = await remoteRequest(shop);
  return purchases;
  // rPurchases = await compute(
  //     _filterAndSort, {"purchases": rPurchases, "query": stringLike});
  // // await saveLocalPurchases(shopToApp(shop), rPurchases);
  // return rPurchases;
  // }
  // ,
  // (x) => compute(_filterAndSort, {"purchases": x, "query": stringLike}),
  // );
  // return inv(purchases);
}

// Future<List> _filterAndSort(Map data) async {
//   var purchases = data['purchases'];
//   // String stringLike = data['query'];
//   // _where(x) =>
//   //     '${x['displayName']}'.toLowerCase().contains(stringLike.toLowerCase());
//
//   // purchases = purchases.where(_where).toList();
//   // purchases.sort((a, b) =>
//   //     '${a['date']}'.toLowerCase().compareTo('${b['date']}'.toLowerCase()));
//   return purchases;
// }

// Future _printPurchaseItems(
//     List carts, discount, customer, wholesale, batchId) async {
//   var items = cartItems(carts, discount, wholesale, '$customer');
//   var data = await cartItemsToPrinterData(items, '$customer', wholesale);
//   await posPrint(data: data, qr: batchId);
// }

Future<Map> _carts2Purchase(List carts, supplier, batchId, pDetail) async {
  var currentUser = await getLocalCurrentUser();
  var t = '${cartTotalAmount(carts, false, (product) => product['purchase'])}';
  var totalAmount = doubleOrZero(t);
  var due = pDetail['due'];
  var type = pDetail['type'];
  var refNumber = pDetail['reference'];
  String? date = pDetail['date'];
  String? dueDate = date;
  if (type == 'invoice' && ((due is String && due.isEmpty) || due == null)) {
    dueDate = toSqlDate(DateTime.now().add(const Duration(days: 30)));
  }
  if (type == 'invoice' && (due is String && due.isNotEmpty)) {
    dueDate = due;
  }
  return {
    "date": date,
    "due": dueDate,
    "refNumber": refNumber,
    "batchId": batchId,
    "amount": totalAmount,
    "supplier": {"name": supplier},
    "user": {"username": currentUser['username'] ?? ''},
    "type": type ?? 'receipt',
    "items": carts.map((e) {
      return {
        "wholesalePrice": e.product['wholesalePrice'],
        "retailPrice": e.product['retailPrice'],
        "product": {
          "id": e.product['id'],
          "product": e.product['product'],
          "stockable": e.product['stockable'] == true,
          "purchase": e.product['purchase'],
          "supplier": supplier
        },
        "amount":
            doubleOrZero('${e.product['purchase']}') * doubleOrZero(e.quantity),
        "purchase": e.product['purchase'],
        "quantity": e.quantity
      };
    }).toList()
  };
}

Future Function(List, String, dynamic) prepareOnSubmitPurchase(context) =>
    (List carts, String customer, discount) async {
      if (customer == null || customer.isEmpty) throw "Supplier required";
      String batchId = generateUUID();
      var shop = await getActiveShop();
      // var url = '${shopFunctionsURL(shopToApp(shop))}/purchase';
      late Map pDetail;
      await addPurchaseDetail(
          context: context,
          onSubmit: (state) {
            pDetail = state;
            navigator().maybePop();
          });
      if (pDetail is! Map) {
        throw 'Purchase details ( reference, date, due and type ) required';
      }
      // await _printPurchaseItems(carts, discount, customer, true, cartId);
      var purchase = await _carts2Purchase(carts, customer, batchId, pDetail);
      var createPurchase = prepareCreatePurchase(purchase);
      return createPurchase(shop);
      // await saveLocalSync(batchId, url, purchase);
      // oneTimeLocalSyncs();
    };
