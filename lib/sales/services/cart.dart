import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/sales/services/printer.dart';

import '../../core/services/cache_shop.dart';
import '../../core/services/cache_user.dart';
import '../../core/services/date.dart';
import '../../core/services/security.dart';
import 'sales.dart';

appendToCarts(cart, List carts) {
  var index = carts.indexWhere((x) => x.product['id'] == cart.product['id']);
  var updateOrAppend = ifDoElse((i) => i == -1, (i) {
    carts.add(cart);
    return carts;
  }, (i) {
    var old = carts[i];
    carts.removeAt(i);
    old.quantity = old.quantity + cart.quantity;
    carts.add(old);
    return carts;
  });
  var allCarts = updateOrAppend(index);
  allCarts.sort(
      (a, b) => '${a.product['product']}'.compareTo('${b.product['product']}'));
  return allCarts;
}

removeCart(String id, List carts) =>
    carts.where((element) => element.product['id'] != id).toList();

updateCartQuantity(String id, int quantity, List carts) => carts.map((e) {
      if (e.product['id'] == id) {
        e.quantity = (e.quantity + quantity) > 1 ? (e.quantity + quantity) : 1;
      }
      return e;
    }).toList();

Future _submitBill(List carts, discount, String cartId, wholesale, customer) async {
  List<dynamic> sales = await _getSalesBatch(carts, discount, wholesale, customer);
  await saveSales(sales, cartId);
}

Future<String> _cartItemsToPrinterData(List<dynamic> carts, String customer,
    {bool wholesale}) async {
  var currentShop = await getActiveShop();
  String data = currentShop['settings']['printerHeader'];
  data = '$data\n-------------------------------\n';
  data = data + (DateTime.now().toUtc().toString());
  if (customer != null) {
    data = '$data-------------------------------\nTo ---> $customer';
  }
  double totalBill = 0.0;
  int sn = 1;
  for (var cart in carts) {
    totalBill += double.parse(cart['amount'].toString());
    data = [
      data,
      '\n-------------------------------\n',
      sn.toString(),
      '.  ',
      cart['product'],
      '\n',
      'Quantity --> ',
      cart['quantity'].toString(),
      ' \t',
      'Unit Price --> ',
      (wholesale == true
          ? cart['stock']['wholesalePrice'].toString()
          : cart['stock']['retailPrice'].toString()),
      '\t',
      'Sub Amount  --> ',
      cart['amount'].toString(),
      ' \t'
    ].join('');

    sn++;
  }
  data = [
    data,
    '\n--------------------------------\n',
    'Total Bill : ',
    totalBill.toString(),
    '\n--------------------------------\n',
  ].join('');
  data = data + currentShop['settings']['printerFooter'];
  return data;
}

Future<List<dynamic>> _getSalesBatch(List carts, dis, wholesale, customer) async {
  var currentUser = await getLocalCurrentUser();
  var discount = int.tryParse('$dis') ?? 0;
  String stringDate = toSqlDate(DateTime.now());
  String stringTime = DateTime.now().toIso8601String();
  String idTra = 'n';
  String channel = wholesale ? 'whole' : 'retail';
  List<dynamic> sales = [];
  for (var value in carts) {
    sales.add({
      "amount": _getCartItemSubAmount(
          totalItems: carts.length,
          totalDiscount: discount,
          product: value.product,
          quantity: value.quantity ?? 0,
          wholesale: wholesale),
      "discount": _getCartItemDiscount(discount, carts.length),
      "quantity": wholesale
          ? (value.quantity ?? 0 * value.product['wholesaleQuantity'])
          : value.quantity,
      "product": value.product['product'],
      "category": value.product['category'],
      "unit": value.product['unit'],
      "channel": channel,
      "date": stringDate,
      "time": stringTime,
      "timer": stringTime,
      "idTra": idTra,
      "customer": customer,
      "customerObject": {'displayName':customer},
      "user": currentUser != null ? currentUser['id'] : null,
      "userObject": currentUser,
      "stock": value.product,
      "stockId": value.product['id']
    });
  }
  return sales;
}

Future printAndSaveCart(List carts, discount, customer, wholesale) async {
  var currentShop = await getActiveShop();
  String cartId = generateUUID();
  List<dynamic> cartItems = _getCartItems(carts, discount, wholesale, '$customer');
  // print(await _cartItemsToPrinterData(cartItems, customer,
  //     wholesale: wholesale));
  if (currentShop['settings']['saleWithoutPrinter'] == false) {
    await PrinterService().posPrint(
      data: await _cartItemsToPrinterData(cartItems, '$customer',
          wholesale: wholesale),
      printer: 'jzv3',
      id: cartId,
      qr: cartId,
    );
  }
  await _submitBill(carts, discount, cartId, wholesale, '$customer');
}

List<dynamic> _getCartItems(List carts, dis, wholesale, customer) =>
    carts.map((value) {
      var discount = int.tryParse('$dis') ?? 0;
      return {
        "amount": _getCartItemSubAmount(
            totalItems: carts.length,
            totalDiscount: discount,
            product: value.product,
            quantity: value.quantity ?? 0,
            wholesale: wholesale),
        "product": value.product['product'],
        'customer': customer,
        'customerObject': {'displayName': customer},
        "quantity": value.quantity,
        "stock": value.product,
        "discount": _getCartItemDiscount(discount, carts.length)
      };
    }).toList();

double _getCartItemDiscount(discount, items) => discount / items;

double _getCartItemSubAmount(
    {int quantity = 0,
    var product,
    int totalDiscount = 0,
    int totalItems = 0,
    bool wholesale = false}) {
  int amount = (wholesale
      ? (quantity * product['wholesalePrice'])
      : (quantity * product['retailPrice'])) as int;
  return amount - _getCartItemDiscount(totalDiscount, totalItems);
}
