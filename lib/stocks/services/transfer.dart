import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/stocks/services/api_transfer.dart';

Future<List<dynamic>> getTransferFromCacheOrRemote(
    {skipLocal = false, stringLike = ''}) async {
  var shop = await getActiveShop();
  List rTransfers = await prepareGetTransfers(stringLike)(shop);
  rTransfers = await compute(
      _filterAndSort, {"transfers": rTransfers, "query": stringLike});
  // await saveLocalTransfers(shopToApp(shop), rTransfers);
  return rTransfers;
  // }
  // ,
  // (x) => compute(_filterAndSort, {"transfers": x, "query": stringLike}),
  // );
  // return inv(transfers);
}

Future<List> _filterAndSort(Map data) async {
  var transfers = data['transfers'];
  // String stringLike = data['query'];
  // _where(x) =>
  //     '${x['displayName']}'.toLowerCase().contains(stringLike.toLowerCase());

  // transfers = transfers.where(_where).toList();
  // transfers.sort((a, b) =>
  //     '${a['date']}'.toLowerCase().compareTo('${b['date']}'.toLowerCase()));
  return transfers;
}

// Future _printTransferItems(
//     List carts, discount, customer, wholesale, batchId) async {
//   var items = cartItems(carts, discount, wholesale, '$customer');
//   var data = await cartItemsToPrinterData(items, '$customer', wholesale);
//   await posPrint(data: data, qr: batchId);
// }

Future<Map> _carts2Transfer(List carts, supplier, batchId) async {
  // var currentUser = await getLocalCurrentUser();
  // var t = '${cartTotalAmount(carts, false, (product) => product['transfer'])}';
  // var totalAmount = doubleOrZero(t);
  // var due = pDetail['due'];
  // var type = pDetail['type'];
  // var refNumber = pDetail['reference'];
  // String? date = pDetail['date'];
  // String? dueDate = date;
  // if (type == 'invoice' && ((due is String && due.isEmpty) || due == null)) {
  //   dueDate = toSqlDate(DateTime.now().add(const Duration(days: 30)));
  // }
  // if (type == 'invoice' && (due is String && due.isNotEmpty)) {
  //   dueDate = due;
  // }
  return {
    // "date": date,
    // "due": dueDate,
    // "refNumber": refNumber,
    // "batchId": batchId,
    // "amount": totalAmount,
    // "supplier": {"name": supplier},
    // "user": {"username": currentUser['username'] ?? ''},
    // "type": type ?? 'receipt',
    "items": carts.map((e) {
      return {
        "wholesalePrice": e.product['wholesalePrice'],
        "retailPrice": e.product['retailPrice'],
        "product": {
          "product": e.product['product'],
          "stockable": e.product['stockable'],
          "transfer": e.product['transfer'],
          "supplier": supplier
        },
        "amount":
            doubleOrZero('${e.product['transfer']}') * doubleOrZero(e.quantity),
        "transfer": e.product['transfer'],
        "quantity": e.quantity
      };
    }).toList()
  };
}

Future Function(List, String, dynamic) prepareOnSubmitTransfer(context) =>
    (List carts, String customer, discount) async {
      if (customer == null || customer.isEmpty) throw "Supplier required";
      String batchId = generateUUID();
      var shop = await getActiveShop();
      // var url = '${shopFunctionsURL(shopToApp(shop))}/transfer';
      late Map pDetail;
      // await addTransferDetail(
      //     context: context,
      //     onSubmit: (state) {
      //       pDetail = state;
      //       navigator().maybePop();
      //     });
      // if (pDetail is! Map) {
      //   throw 'Transfer details ( reference, date, due and type ) required';
      // }
      // await _printTransferItems(carts, discount, customer, true, cartId);
      var transfer = await _carts2Transfer(carts, customer, batchId);
      // var createTransfer = prepareCreateTransfer(transfer);
      // return createTransfer(shop);
      // await saveLocalSync(batchId, url, transfer);
      // oneTimeLocalSyncs();
    };

Future getOtherShopsNames({skipLocal = false, stringLike = ''}) async {
  var shop = await getActiveShop();
  var getBusinessName = propertyOr('businessName', (p0) => 'No Shop');
  var user = await getLocalCurrentUser();
  var getShops = compose([
    (shops) => shops
        .where((element) => element['name'] != getBusinessName(shop))
        .toList(),
    (shops) {
      shops.add({'name': user['businessName'] ?? ''});
      return shops;
    },
    (shops) => shops.map((e) => {'name': e}).toList(),
    (shops) => shops.map(getBusinessName).toList(),
    propertyOr('shops', (p0) => []),
  ]);
  return getShops(user);
}
