import 'dart:async';

import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/printer.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/sync.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/services/api_invoice.dart';

Future<List> getInvoiceSalesFromCacheOrRemote(
    startAt, size, [String filterBy='customer', String filterValue='']) async {
  var shop = await getActiveShop();
  var getInvoices = prepareGetRemoteInvoiceSales(
      size: size,
      filterBy: filterBy,
      filterValue: filterValue,
      startAt: startAt);
  return await getInvoices(shop);
}

Future _printInvoiceItems(List carts, discount, Map customer, batchId) async {
  var items = cartItems(carts, discount, false, customer);
  var data = await cartItemsToPrinterData(
      items, customer, (cart) => cart['stock']['retailPrice']);
  await posPrint(data: data, qr: batchId);
}

Future<Map> _carts2Invoice(List carts, dis, Map customer, cartId, batchId) async {
  var discount = doubleOrZero('$dis');
  var totalAmount = doubleOrZero(
      '${cartTotalAmount(carts, false, (product) => product['retailPrice'])}');
  String date = toSqlDate(DateTime.now());
  String due = toSqlDate(DateTime.now().add(const Duration(days: 14)));
  return {
    "date": date,
    "dueDate": due,
    "channel": 'invoice',
    "amount": totalAmount - discount,
    "customer": customer,
    "status": "not paid",
    "batchId": batchId,
    "items": carts.map((cart) {
      return {
        "amount": getCartItemSubAmount(
            totalItems: carts.length,
            totalDiscount: discount,
            product: cart.product,
            quantity: cart.quantity ?? 0),
        "quantity": cart.quantity ?? 0,
        "stock": {
          "product": cart.product['product'],
          "category": cart.product['category'],
          "stockable": cart.product['stockable'],
          "id": cart.product['id'],
          "purchase": cart.product['purchase'],
        }
      };
    }).toList()
  };
}

Future onSubmitInvoice(List carts, Map customer, discount) async {
  if ('${customer['displayName']??''}'.isEmpty) {
    throw "Please select customer, at the top right of the cart.";
  }
  String cartId = generateUUID();
  String batchId = generateUUID();
  var shop = await getActiveShop();
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/invoice';
  var invoice =
      await _carts2Invoice(carts, discount, customer, cartId, batchId);
  var offlineFirst = await isOfflineFirstEnv();
  if (offlineFirst == true) {
    await saveLocalSync(batchId, url, invoice);
    oneTimeLocalSyncs();
  } else {
    var saveInvoice = prepareHttpPutRequest(invoice);
    await saveInvoice(url);
  }
  _printInvoiceItems(carts, discount, customer, cartId).catchError((e) => null);
}
