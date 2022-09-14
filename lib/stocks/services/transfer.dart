import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/account.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/printer.dart';
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

Future _printTransferItems(List carts, discount, customer, batchId) async {
  var items = cartItems(carts, discount, false, '$customer');
  var data = await cartItemsToPrinterData(
      items, '$customer', (cart) => cart['stock']['purchase']);
  await posPrint(data: data, qr: batchId);
}

Future<Map> _carts2Transfer(List carts, shop2Name, batchId, shop1, type) async {
  var shop2 = await shopName2Shop(shop2Name);
  var currentUser = await getLocalCurrentUser();
  var t = '${cartTotalAmount(carts, false, (product) => product['purchase'])}';
  var totalAmount = doubleOrZero(t);
  return {
    "date": DateTime.now().toIso8601String(),
    "transferred_by": {"username": currentUser['username']},
    "note": ".",
    "batchId": batchId,
    "amount": totalAmount,
    "to_shop": {
      "name": type == 'send' ? shop2['businessName'] : shop1['businessName'],
      "projectId": type == 'send' ? shop2['projectId'] : shop1['projectId'],
      "applicationId":
          type == 'send' ? shop2['applicationId'] : shop1['applicationId'],
    },
    "from_shop": {
      "name": type == 'send' ? shop1['businessName'] : shop2['businessName'],
      "projectId": type == 'send' ? shop1['projectId'] : shop2['projectId'],
      "applicationId":
          type == 'send' ? shop1['applicationId'] : shop2['applicationId'],
    },
    "items": carts.map((e) {
      return {
        "from_id": e.product['id'],
        "from_product": e.product['product'],
        "to_product": e.product['product'],
        "to_id": e.product['id'],
        "to_purchase": e.product['purchase'],
        "from_purchase": e.product['purchase'],
        "to_retail": e.product['retailPrice'],
        "to_whole": e.product['wholesalePrice'],
        "product": e.product['product'],
        "quantity": e.quantity,
      };
    }).toList()
  };
}

Future Function(List, String, dynamic) prepareOnSubmitTransfer(
        context, String type) =>
    (List carts, String shopName, discount) async {
      if (shopName.isEmpty) throw "Shop you transfer to/from required";
      String batchId = generateUUID();
      var shop = await getActiveShop();
      // var url = '${shopFunctionsURL(shopToApp(shop))}/transfer/$type';
      if (type == 'send') {
        await _printTransferItems(carts, discount, shopName, generateUUID());
      }
      var transfer =
          await _carts2Transfer(carts, shopName, batchId, shop, type);
      // print(transfer);
      var saveTransfer = ifDoElse(
        (_) => type == 'send',
        composeAsync([prepareSendTransfer(transfer)]),
        composeAsync([prepareReceiveTransfer(transfer)]),
      );
      return saveTransfer(shop);
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
