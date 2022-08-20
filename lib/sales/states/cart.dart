import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/cache_user.dart';
import 'package:smartstock_pos/sales/services/sales.dart';

import '../../core/services/date.dart';
import '../../core/services/security.dart';
import '../../core/services/util.dart';
import '../models/cart.model.dart';
import '../services/printer.dart';

class CartState extends ChangeNotifier {
  final TextEditingController quantityInputController =
      TextEditingController(text: '1');
  final TextEditingController discountInputController =
      TextEditingController(text: '0');
  List<CartModel> cartProductsArray = [];
  CartModel currentCartModel;
  bool checkoutProgress = false;
  final PrinterService _printerService = PrinterService();

  addStockToCart(CartModel cart) {
    CartModel updateItem = cartProductsArray.firstWhere(
        (x) => x.product['id'] == cart.product['id'],
        orElse: () => CartModel(product: null, quantity: null));
    if (updateItem.product != null) {
      var index = cartProductsArray.indexOf(updateItem);
      cartProductsArray[index].quantity =
          cartProductsArray[index].quantity + (cart.quantity);
    } else {
      cartProductsArray.add(cart);
    }
    notifyListeners();
  }

  int calculateCartItems() {
    return cartProductsArray
        .map<int>((cartItem) => cartItem.quantity ?? 0)
        .reduce((value, element) => value + element);
  }

  int getTotalWithoutDiscount({bool isWholesale = false}) {
    if (cartProductsArray.isEmpty || cartProductsArray == null) {
      return 0;
    }
    int total = cartProductsArray
        .map<int>((value) =>
            value.quantity *
            (isWholesale
                ? value.product['wholesalePrice'] as int
                : value.product['retailPrice'] as int))
        .reduce((a, b) => a + b);
    return total;
  }

  int getFinalTotal({bool isWholesale = false}) {
    if (cartProductsArray.isEmpty || cartProductsArray == null) {
      return 0;
    }
    int discount = int.parse(discountInputController.text.isNotEmpty
        ? discountInputController.text
        : '0');
    int total = cartProductsArray
            .map<int>((value) =>
                value.quantity *
                (isWholesale
                    ? value.product['wholesalePrice'] as int
                    : value.product['retailPrice'] as int))
            .reduce((a, b) => a + b) -
        discount;
//    discountInputController.selection = TextSelection.fromPosition(
//        TextPosition(offset: discountInputController.text.length));
    return total;
  }

  void decrementQtyOfProductInCart(String productId) {
    int indexOfProductInCart = cartProductsArray
        .indexWhere((element) => element.product['id'] == productId);
    if (indexOfProductInCart >= 0 &&
        (cartProductsArray[indexOfProductInCart].quantity) > 1) {
      cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity - 1;
      notifyListeners();
    }
  }

  void incrementQtyOfProductInCart(String productId) {
    int indexOfProductInCart = cartProductsArray
        .indexWhere((element) => element.product['id'] == productId);
    if (indexOfProductInCart >= 0) {
      cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity + 1;
      notifyListeners();
    }
  }

  void removeCart(CartModel cartModel, wholesale) {
    cartProductsArray.retainWhere(
        (element) => element.product['id'] != cartModel.product['id']);
    if (cartProductsArray.isEmpty) {
      navigateToAndReplace(wholesale ? '/sales/whole' : '/sales/retail');
    }
    notifyListeners();
  }

  void incrementQtyOfProductToBeAddedToCart() {
    if (currentCartModel != null && currentCartModel?.quantity != null) {
      currentCartModel?.quantity = currentCartModel.quantity + 1;
      quantityInputController.text = currentCartModel.quantity.toString();
      notifyListeners();
    }
  }

  void setCartQuantity(String value) {
    if (value.isEmpty) return;
    try {
      currentCartModel?.quantity = int.parse(value);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  void setCartDiscount(String value) {
    discountInputController.text = value;
    notifyListeners();
  }

  void decrementQtyOfProductToBeAddedToCart() {
    if (currentCartModel != null &&
        currentCartModel?.quantity != null &&
        currentCartModel.quantity > 1) {
      currentCartModel?.quantity = currentCartModel?.quantity ?? 0 - 1;
      quantityInputController.text =
          currentCartModel?.quantity.toString() ?? '';
      notifyListeners();
    }
  }

  void setCurrentCartToBeAdded(CartModel cartModel) {
    if (cartModel == null) {
      quantityInputController.text = '1';
    } else {
      quantityInputController.text = cartModel.quantity.toString();
    }
    currentCartModel = cartModel;
    notifyListeners();
  }

  Future checkout({bool wholesale}) async {
    try {
      checkoutProgress = true;
      notifyListeners();
      await printCart(wholesale: wholesale);
    } finally {
      checkoutProgress = false;
      notifyListeners();
    }
  }

  Future submitBill(String cartId, wholesale) async {
    List<dynamic> sales = await _getSalesBatch();
    await saveSales(sales, cartId);
    cartProductsArray = [];
    currentCartModel = null;
    navigateToAndReplace(wholesale ? '/sales/whole' : '/sales/retail');
    // this.customerFormControl.setValue(null);
  }

  Future<String> _cartItemsToPrinterData(List<dynamic> carts, String customer,
      {bool wholesale}) async {
    var currentShop = await getActiveShop();
    // print(currentShop);
    String data = currentShop['settings']['printerHeader'];
    data = '$data\n-------------------------------\n';
    data = data + (DateTime.now().toUtc().toString());
//  if (customer) {
//  data = data.concat('-------------------------------\nTo ---> ' + customer);
//  }
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

  Future<List<dynamic>> _getSalesBatch({bool wholesale = false}) async {
    var currentUser = await getLocalCurrentUser();
    String discount = discountInputController.text.isNotEmpty
        ? discountInputController.text
        : '0';
    String stringDate = toSqlDate(DateTime.now());
    String stringTime = DateTime.now().toIso8601String();
    String idTra = 'n';
    String channel = wholesale ? 'whole' : 'retail';
    List<dynamic> sales = [];
    for (var value in cartProductsArray) {
      sales.add({
        "amount": _getCartItemSubAmount(
            totalItems: cartProductsArray.length,
            totalDiscount: int.parse(discount),
            product: value.product,
            quantity: value.quantity ?? 0,
            wholesale: wholesale),
        "discount": _getCartItemDiscount(
          totalItems: cartProductsArray.length,
          totalDiscount: int.parse(discount),
        ),
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
        "customer": null,
        "user": currentUser != null ? currentUser['id'] : null,
        "userObject": currentUser,
        "stock": value.product,
        "stockId": value.product['id']
      });
    }
    return sales;
  }

  Future printCart({bool wholesale}) async {
    try {
      var currentShop = await getActiveShop();
      checkoutProgress = true;
      notifyListeners();
      String cartId = generateUUID();
      List<dynamic> cartItems = _getCartItems(wholesale: wholesale);
      if (currentShop['settings']['saleWithoutPrinter'] == false) {
        await _printerService.posPrint(
          data: await _cartItemsToPrinterData(cartItems, wholesale ? "" : null,
              wholesale: wholesale),
          printer: 'jzv3',
          id: cartId,
          qr: cartId,
        );
      }
      await submitBill(cartId, wholesale);
    } finally {
      checkoutProgress = false;
      notifyListeners();
    }
  }

  List<dynamic> _getCartItems({@required wholesale}) {
    return cartProductsArray.map((value) {
      var discount = discountInputController.text.isNotEmpty
          ? discountInputController.text
          : '0';
      return {
        "amount": _getCartItemSubAmount(
          totalItems: cartProductsArray.length,
          totalDiscount: int.parse(discount),
          product: value.product,
          quantity: value.quantity ?? 0,
          wholesale: wholesale,
        ),
        "product": value.product['product'],
        "quantity": value.quantity,
        "stock": value.product,
        "discount": _getCartItemDiscount(
          totalItems: cartProductsArray.length,
          totalDiscount: int.parse(discount),
        )
      };
    }).toList();
  }

  double _getCartItemDiscount({int totalDiscount = 0, int totalItems = 0}) {
    return (totalDiscount / totalItems);
  }

  double _getCartItemSubAmount(
      {int quantity = 0,
      var product,
      int totalDiscount = 0,
      int totalItems = 0,
      bool wholesale = false}) {
    int amount = (wholesale
        ? (quantity * product['wholesalePrice'])
        : (quantity * product['retailPrice'])) as int;
    return amount -
        _getCartItemDiscount(
            totalDiscount: totalDiscount, totalItems: totalItems);
  }

  @override
  void dispose() {
    quantityInputController.dispose();
    discountInputController.dispose();
    super.dispose();
  }
}
