import 'package:bfast/util.dart';

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

cartTotalAmount(List carts, wholesale) =>
    carts.fold(0, (t, element) => t + getProductPrice(element, wholesale));

getProductPrice(cart, bool wholesale) => wholesale
    ? cart.product['wholesalePrice'] * cart.quantity
    : cart.product['retailPrice'] * cart.quantity;

double getCartItemSubAmount(
    {int quantity = 0,
    var product,
    int totalDiscount = 0,
    int totalItems = 0,
    bool wholesale = false}) {
  int amount = (wholesale
      ? (quantity * product['wholesalePrice'])
      : (quantity * product['retailPrice'])) as int;
  return amount - getCartItemDiscount(totalDiscount, totalItems);
}

double getCartItemDiscount(discount, items) => discount / items;

List cartItems(List carts, dis, wholesale, customer) => carts.map((value) {
      var discount = int.tryParse('$dis') ?? 0;
      return {
        "amount": getCartItemSubAmount(
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
        "discount": getCartItemDiscount(discount, carts.length)
      };
    }).toList();

Future<String> cartItemsToPrinterData(
    List<dynamic> carts, String customer, wholesale) async {
  String data = '';
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
  return data;
}

// Future _submitBill(List carts, discount, String cartId, wholesale, customer) async {
//   List<dynamic> sales = await _getSalesBatch(carts, discount, wholesale, customer);
//   await saveSales(sales, cartId);
// }
