import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/printer.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/sync.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/api_invoice.dart';
import 'package:smartstock/sales/services/cart.dart';

Future<List<dynamic>> getInvoiceFromCacheOrRemote({
  skipLocal = false,
  stringLike = '',
}) async {
  var shop = await getActiveShop();
  // var invoices = [];
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

Future _printInvoiceItems(
    List carts, discount, customer, wholesale, batchId) async {
  var items = cartItems(carts, discount, wholesale, '$customer');
  var data = await cartItemsToPrinterData(items, '$customer', wholesale);
  await posPrint(data: data, qr: batchId);
}

Future<Map> _carts2Invoice(
    List carts, dis, wholesale, customer, cartId, batchId) async {
  var discount = int.tryParse('$dis') ?? 0;
  var totalAmount = int.tryParse('${cartTotalAmount(carts, false)}') ?? 0;
  String date = toSqlDate(DateTime.now());
  String due = toSqlDate(DateTime.now().add(const Duration(days: 14)));
  return {
    "date": date,
    "dueDate": due,
    "channel": 'invoice',
    "amount": totalAmount - discount,
    "customer": {"displayName": customer},
    "status": "not paid",
    "batchId": batchId,
    "items": carts.map((cart) {
      return {
        "amount": getCartItemSubAmount(
            totalItems: carts.length,
            totalDiscount: discount,
            product: cart.product,
            quantity: cart.quantity ?? 0,
            wholesale: wholesale),
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

Future onSubmitInvoice(List carts, String customer, discount) async {
  if (customer == null || customer.isEmpty) throw "Customer required";
  String cartId = generateUUID();
  String batchId = generateUUID();
  var shop = await getActiveShop();
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/invoice';
  await _printInvoiceItems(carts, discount, customer, true, cartId);
  var invoice =
      await _carts2Invoice(carts, discount, true, customer, cartId, batchId);
  await saveLocalSync(batchId, url, invoice);
  oneTimeLocalSyncs();
}
