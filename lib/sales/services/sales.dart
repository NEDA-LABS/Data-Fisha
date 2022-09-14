import 'package:smartstock/core/services/api.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_sync.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/printer.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/core/services/sync.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/core/services/cart.dart';

Future<List> _carts2Sales(List carts, dis, wholesale, customer, cartId) async {
  var currentUser = await getLocalCurrentUser();
  var discount = doubleOrZero('$dis');
  String stringDate = toSqlDate(DateTime.now());
  String stringTime = DateTime.now().toIso8601String();
  String channel = wholesale ? 'whole' : 'retail';
  return carts
      .map((value) => ({
            "amount": getCartItemSubAmount(
                totalItems: carts.length,
                totalDiscount: discount,
                product: value.product,
                quantity: value.quantity ?? 0,
                wholesale: wholesale),
            "discount": getCartItemDiscount(discount, carts.length),
            "quantity": wholesale
                ? (value.quantity ?? 0 * value.product['wholesaleQuantity'])
                : value.quantity,
            "product": value.product['product'],
            "category": value.product['category'] ?? 'general',
            "unit": value.product['unit'] ?? 'general',
            "channel": channel,
            "date": stringDate,
            // "time": stringTime,
            "timer": stringTime,
            "customer": customer,
            "customerObject": {'displayName': customer},
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
            "stockId": value.product['id']
          }))
      .toList();
}

Future _printSaleItems(
    List carts, discount, customer, wholesale, batchId) async {
  var items = cartItems(carts, discount, wholesale, '$customer');
  var data = await cartItemsToPrinterData(items, '$customer', wholesale);
  await posPrint(data: data, qr: batchId);
}

_onSubmitSale(List carts, String customer, discount, wholesale)async{
  String cartId = generateUUID();
  String batchId = generateUUID();
  var shop = await getActiveShop();
  var url = '${shopFunctionsURL(shopToApp(shop))}/sale/cash';
  await _printSaleItems(carts, discount, customer, wholesale, cartId);
  var sales = await _carts2Sales(carts, discount, wholesale, customer, cartId);
  if(isWebMobilePlatform()){
    var saveSales = preparePostRequest(sales);
    return saveSales(url);
  }else{
    await saveLocalSync(batchId, url, sales);
    oneTimeLocalSyncs();
  }
}
Future onSubmitRetailSale(List carts, String customer, discount) async {
  return _onSubmitSale(carts, customer, discount, false);
}

Future onSubmitWholeSale(List carts, String customer, discount) async {
  if (customer == null || customer.isEmpty) throw "Customer required";
  return _onSubmitSale(carts, customer, discount, true);
}
