import 'package:flutter/cupertino.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/cache_user.dart';
import 'package:smartstock_pos/core/services/util.dart';

import '../../core/services/date.dart';
import '../../core/services/security.dart';
import '../models/cart.model.dart';
import '../services/printer.dart';
import '../services/sales.dart';

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
        orElse: () => CartModel(product: null, quantity: null)
    );
    if (updateItem.product != null) {
      var index = cartProductsArray.indexOf(updateItem);
      cartProductsArray[index].quantity =
      (cartProductsArray[index].quantity) + (cart.quantity);
    } else {
      cartProductsArray.add(cart);
    }
    notifyListeners();
  }

  int calculateCartItems() {
    return cartProductsArray
        .map<int>((cartItem) => cartItem.quantity??0)
        .reduce((value, element) => value + element);
  }

  int getTotalWithoutDiscount({bool isWholesale = false}) {
    if(cartProductsArray.isEmpty || cartProductsArray == null){
      return 0;
    }
    int total = cartProductsArray
        .map<int>((value) =>
            value.quantity??0 *
            (isWholesale
                ? value.product['wholesalePrice'] as int
                : value.product['retailPrice'] as int))
        .reduce((a, b) => a + b);
//    discountInputController.selection = TextSelection.fromPosition(
//        TextPosition(offset: discountInputController.text.length));
    return total;
  }

  int getFinalTotal({bool isWholesale = false}) {
    if(cartProductsArray.isEmpty || cartProductsArray == null){
      return 0;
    }
    int total = cartProductsArray.map<int>((value) =>
                value.quantity??0 *
                (isWholesale
                    ? value.product['wholesalePrice'] as int
                    : value.product['retailPrice'] as int))
            .reduce((a, b) => a + b) -
        int.parse(discountInputController.text.isNotEmpty
            ? discountInputController.text
            : '0');
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
          cartProductsArray[indexOfProductInCart].quantity??0 - 1;
      notifyListeners();
    }
  }

  void incrementQtyOfProductInCart(String productId) {
    int indexOfProductInCart = cartProductsArray
        .indexWhere((element) => element.product['id'] == productId);
    if (indexOfProductInCart >= 0) {
      cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity??0 + 1;
      notifyListeners();
    }
  }

  void removeCart(CartModel cartModel) {
    cartProductsArray.retainWhere((element) =>
        element.product['id'] != cartModel.product['id']);
    if (cartProductsArray.isEmpty) {
      navigator().pop();
    }
    notifyListeners();
  }

  void incrementQtyOfProductToBeAddedToCart() {
    if (currentCartModel != null && currentCartModel?.quantity != null) {
      currentCartModel?.quantity = currentCartModel?.quantity??0 + 1;
      quantityInputController.text = currentCartModel?.quantity.toString()??'';
      notifyListeners();
    }
  }

  void setCartQuantity(String value) {
    currentCartModel?.quantity = int.parse(value);
    quantityInputController.text = value;
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
      currentCartModel?.quantity = currentCartModel?.quantity??0 - 1;
      quantityInputController.text = currentCartModel?.quantity.toString()??'';
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

  Future checkout() async {
    try {
      checkoutProgress = true;
      notifyListeners();
      await printCart();
    } finally {
      checkoutProgress = false;
      notifyListeners();
    }
  }

  Future submitBill(String cartId) async {
    List<dynamic> sales = await _getSalesBatch();
    await saveSales(sales, cartId);
    cartProductsArray = [];
    currentCartModel = null;
    navigator().pop();
    // this.customerFormControl.setValue(null);
  }

  Future<String> _cartItemsToPrinterData(List<dynamic> carts, String customer,
      { bool wholesale}) async {
    var currentShop = await getActiveShop();
    // print(currentShop);
    String data = '';
    data = '$data-------------------------------\n';
    data = data + (DateTime.now().toUtc().toString());
//  if (customer) {
//  data = data.concat('-------------------------------\nTo ---> ' + customer);
//  }
    double totalBill = 0.0;
    int sn = 1;
    carts.forEach((cart) {
      totalBill += double.parse(cart['amount'].toString());
      data = data +
          '\n-------------------------------\n' +
          sn.toString() +
          '.  ' +
          cart['product'] +
          '\n' +
          'Quantity --> ' +
          cart['quantity'].toString() +
          ' \t' +
          'Unit Price --> ' +
          (wholesale == true
              ? cart['stock']['wholesalePrice'].toString()
              : cart['stock']['retailPrice'].toString()) +
          '\t' +
          'Sub Amount  --> ' +
          cart['amount'].toString() +
          ' \t';

      sn++;
    });
    data = data +
        ('\n--------------------------------\n' +
            'Total Bill : ' +
            totalBill.toString() +
            '\n--------------------------------\n');
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
    this.cartProductsArray.forEach((value) {
      sales.add({
        "amount": this._getCartItemSubAmount(
            totalItems: this.cartProductsArray.length,
            totalDiscount: int.parse(discount),
            product: value.product,
            quantity: value.quantity??0,
            wholesale: wholesale),
        "discount": _getCartItemDiscount(
          totalItems: this.cartProductsArray.length,
          totalDiscount: int.parse(discount),
        ),
        "quantity": wholesale
            ? (value.quantity??0 * value.product['wholesaleQuantity'])
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
    });
    return sales;
  }

  Future printCart({bool wholesale = false}) async {
    try {
      var currentShop = await getActiveShop();
      this.checkoutProgress = true;
      notifyListeners();
      String cartId = generateUUID();
      List<dynamic> cartItems = this._getCartItems(wholesale: wholesale);
      if (currentShop['settings']['saleWithoutPrinter'] == false) {
        await this._printerService.posPrint(
              data: await this._cartItemsToPrinterData(
                  cartItems, wholesale ? "" : null,
                  wholesale: wholesale),
              printer: 'jzv3',
              id: cartId,
              qr: cartId,
            );
      }
      await this.submitBill(cartId);
    } finally {
      checkoutProgress = false;
      notifyListeners();
    }
  }

  List<dynamic> _getCartItems({@required wholesale}) {
    return this.cartProductsArray.map((value) {
      var discount = this.discountInputController.text.isNotEmpty
          ? discountInputController.text
          : '0';
      return {
        "amount": this._getCartItemSubAmount(
          totalItems: this.cartProductsArray.length,
          totalDiscount: int.parse(discount),
          product: value.product,
          quantity: value.quantity??0,
          wholesale: wholesale,
        ),
        "product": value.product['product'],
        "quantity": value.quantity,
        "stock": value.product,
        "discount": _getCartItemDiscount(
          totalItems: this.cartProductsArray.length,
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

  @override
  void onDispose() => dispose();
}
