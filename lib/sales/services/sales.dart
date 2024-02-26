import 'dart:async';

import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/printer.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/sync.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/api_cash_sale.dart';

Future<List> getCashSalesFromCacheOrRemote(
    {required startAt,
    required size,
    required String filterBy,
    required String filterValue}) async {
  var shop = await getActiveShop();
  var getSales = prepareGetRemoteCashSales(
      startAt: startAt,
      size: size,
      filterValue: filterValue,
      filterBy: filterBy);
  List sales = await getSales(shop);
  return sales;
}

Future<List> _cartToCashSale(
    {required List carts,
    required double discount,
    required Map customer,
    required String cartId,
    required double taxPercentage}) async {
  var currentUser = await getLocalCurrentUser();
  // var discount = doubleOrZero('$dis');
  String stringDate = toSqlDate(DateTime.now());
  String stringTime = DateTime.now().toIso8601String();
  String channel = 'retail';
  return carts.map((value) {
    return {
      "amount": getCartItemSubAmount(
        totalItems: carts.length,
        totalDiscount: discount,
        product: value.product,
        quantity: value.quantity ?? 0,
      ),
      "discount": (discount / carts.length),
      "quantity": value.quantity,
      "product": value.product['product'],
      "category": value.product['category'] ?? 'general',
      // "unit": value.product['unit'] ?? 'general',
      "channel": channel,
      "date": stringDate,
      // "time": stringTime,
      "timer": stringTime,
      "customer": customer['displayName'] ?? '',
      "customerObject": {
        "id": '${customer['id'] ?? '0'}',
        'displayName': '${customer['displayName'] ?? customer['name'] ?? ''}'
      },
      "user": currentUser['username'] ?? 'null',
      "sellerObject": {
        "username": currentUser['username'] ?? '',
        "lastname": currentUser['lastname'] ?? '',
        "firstname": currentUser['firstname'] ?? '',
        "email": currentUser['email'] ?? ''
      },
      "stock": value.product,
      "cartId": cartId,
      "batch": generateUUID(),
      "stockId": value.product['id'],
      "metadata": {"tax": taxPercentage / carts.length}
    };
  }).toList();
}

Future onSubmitCashSale({
  required List<CartModel> carts,
  required double discount,
  required Map customer,
  required double taxPercentage,
  required String cartId,
}) async {
  var shop = await getActiveShop();
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/cash';
  var sales = await _cartToCashSale(
    carts: carts,
    customer: customer,
    discount: discount,
    taxPercentage: taxPercentage,
    cartId: cartId,
  );
  var offlineFirst = await isOfflineFirstEnv();
  if (offlineFirst == true) {
    String lid = generateUUID();
    await saveLocalSync(lid, url, sales);
    oneTimeLocalSyncs();
  } else {
    var saveSales = prepareHttpPostRequest(sales);
    await saveSales(url);
  }
}

// Future printSaleCartItems({
//   required List<CartModel> carts,
//   required double discount,
//   required Map customer,
//   required int taxPercentage,
// }) async {
//   var items = cartItems(carts, discount, customer);
//   var data = await cartItemsToPrinterData(
//       items, customer, (cart) => cart['stock']['retailPrice']);
//   await posPrint(data: data);
// }

// Future onSubmitWholeSale(List<CartModel> carts, Map customer, discount) async {
//   if ('${customer['displayName']??''}'.isEmpty) {
//     throw "Please select customer, at the top right of the cart";
//   }
//   return _onSubmitSale(carts, customer, discount, true);
// }

Future rePrintASale(sale) async {
  mapItem(item) {
    item['product'] =
        compose([propertyOrNull('product'), propertyOrNull('stock')])(item);
    return item;
  }

  var getItems = compose([
    (x) => x.map(mapItem).toList(),
    itOrEmptyArray,
    propertyOrNull('items')
  ]);
  var getDate = propertyOrNull('timer');
  var getCustomer = ifDoElse(
    (f) => f is Map && f['customer'] is Map,
    compose(
      [
        propertyOr('displayName', (_) => ''),
        propertyOrNull('customer'),
      ],
    ),
    propertyOr('customer', (_) => ''),
  );
  var getAmount = propertyOr('amount', (p0) => 0);
  var getQuantity = propertyOr('quantity', (p0) => 0);
  onGetPrice(item) {
    var amount = getAmount(item);
    var quantity = getQuantity(item);
    return amount / quantity;
  }

  var getId = propertyOr('id', (p0) => 0);
  var data = await cartItemsToPrinterData(
      getItems(sale), getCustomer(sale), onGetPrice,
      date: getDate(sale));
  await posPrint(data: data, force: true, qr: getId(sale));
}
