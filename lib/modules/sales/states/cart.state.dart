import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/services/printer.service.dart';
import 'package:smartstock_pos/modules/sales/services/sales.service.dart';
import 'package:smartstock_pos/shared/date.utils.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';
import 'package:smartstock_pos/shared/security.utils.dart';

class CartState extends BFastUIState {
  final TextEditingController quantityInputController =
      TextEditingController(text: '1');
  final TextEditingController discountInputController =
      TextEditingController(text: '0');
  List<CartModel> cartProductsArray = [];
  CartModel currentCartModel;
  bool checkoutProgress = false;
  PrinterService _printerService = PrinterService();

  SalesService _salesService = SalesService();

  addStockToCart(CartModel cart) {
    CartModel updateItem = this.cartProductsArray.firstWhere(
        (x) => x.product['id'] == cart.product['id'],
        orElse: () => null);
    if (updateItem != null) {
      var index = this.cartProductsArray.indexOf(updateItem);
      this.cartProductsArray[index].quantity =
          this.cartProductsArray[index].quantity + cart.quantity;
    } else {
      this.cartProductsArray.add(cart);
    }
    notifyListeners();
  }

  int calculateCartItems() {
    return this
        .cartProductsArray
        .map<int>((cartItem) => cartItem.quantity)
        .reduce((value, element) => value + element);
  }

  int getTotalWithoutDiscount({bool isWholesale = false}) {
    if(this.cartProductsArray.isEmpty || this.cartProductsArray == null){
      return 0;
    }
    int total = this
        .cartProductsArray
        .map<int>((value) =>
            value.quantity *
            (isWholesale
                ? value.product['wholesalePrice']
                : value.product['retailPrice']))
        .reduce((a, b) => a + b);
//    discountInputController.selection = TextSelection.fromPosition(
//        TextPosition(offset: discountInputController.text.length));
    return total;
  }

  int getFinalTotal({bool isWholesale = false}) {
    if(this.cartProductsArray.isEmpty || this.cartProductsArray == null){
      return 0;
    }
    int total = this
            .cartProductsArray
            .map<int>((value) =>
                value.quantity *
                (isWholesale
                    ? value.product['wholesalePrice']
                    : value.product['retailPrice']))
            .reduce((a, b) => a + b) -
        int.parse(this.discountInputController.text.isNotEmpty
            ? this.discountInputController.text
            : '0');
//    discountInputController.selection = TextSelection.fromPosition(
//        TextPosition(offset: discountInputController.text.length));
    return total;
  }

  void decrementQtyOfProductInCart(String productId) {
    int indexOfProductInCart = cartProductsArray
        .indexWhere((element) => element.product['id'] == productId);
    if (indexOfProductInCart >= 0 &&
        this.cartProductsArray[indexOfProductInCart].quantity > 1) {
      this.cartProductsArray[indexOfProductInCart].quantity =
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

  void removeCart(CartModel cartModel) {
    this.cartProductsArray.retainWhere((element) =>
        element.product['id'] != cartModel.product['id']);
    if (cartProductsArray.length == 0) {
      BFastUI.navigator().pop();
    }
    notifyListeners();
  }

  void incrementQtyOfProductToBeAddedToCart() {
    if (currentCartModel != null && currentCartModel.quantity != null) {
      currentCartModel.quantity += 1;
      quantityInputController.text = currentCartModel.quantity.toString();
      notifyListeners();
    }
  }

  void setCartQuantity(String value) {
    currentCartModel.quantity = int.parse(value);
    quantityInputController.text = value;
    notifyListeners();
  }

  void setCartDiscount(String value) {
    discountInputController.text = value;
    notifyListeners();
  }

  void decrementQtyOfProductToBeAddedToCart() {
    if (currentCartModel != null &&
        currentCartModel.quantity != null &&
        currentCartModel.quantity > 1) {
      currentCartModel.quantity -= 1;
      quantityInputController.text = currentCartModel.quantity.toString();
      notifyListeners();
    }
  }

  void setCurrentCartToBeAdded(CartModel cartModel) {
    if (cartModel == null) {
      quantityInputController.text = '1';
    } else {
      quantityInputController.text = cartModel.quantity.toString();
    }
    this.currentCartModel = cartModel;
    notifyListeners();
  }

  Future checkout() async {
    try {
      //    if (this.isViewedInWholesale && !this.customerFormControl.valid) {
//      this.snack.open('Please enter customer name, at least three characters required', 'Ok', {
//        duration: 3000
//      });
//      return;
//    }

      this.checkoutProgress = true;
      notifyListeners();

//    if (this.customerFormControl.valid) {
//      this.customerApi.saveCustomer({
//        displayName: this.customerFormControl.value,
//      }).catch();
//    }

      await this.printCart();
    } finally {
      this.checkoutProgress = false;
      notifyListeners();
    }
  }

  Future submitBill(String cartId) async {
    List<dynamic> sales = await this._getSalesBatch();
    await this._salesService.saveSales(sales, cartId);
    this.cartProductsArray = [];
    currentCartModel = null;
    BFastUI.navigator().pop();
    // this.customerFormControl.setValue(null);
  }

  Future<String> _cartItemsToPrinterData(List<dynamic> carts, String customer,
      {@required bool wholesale}) async {
    var currentShop = await SmartStockPosLocalStorage().getActiveShop();
    print(currentShop);
    String data = '';
    data = data + '-------------------------------\n';
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
    var currentUser = await BFast.auth().currentUser();
    String discount = discountInputController.text.isNotEmpty
        ? discountInputController.text
        : '0';
    String stringDate = toSqlDate(DateTime.now());
    String idTra = 'n';
    String channel = wholesale ? 'whole' : 'retail';
    List<dynamic> sales = [];
    this.cartProductsArray.forEach((value) {
      sales.add({
        "amount": this._getCartItemSubAmount(
            totalItems: this.cartProductsArray.length,
            totalDiscount: int.parse(discount),
            product: value.product,
            quantity: value.quantity,
            wholesale: wholesale),
        "discount": _getCartItemDiscount(
          totalItems: this.cartProductsArray.length,
          totalDiscount: int.parse(discount),
        ),
        "quantity": wholesale
            ? (value.quantity * value.product['wholesaleQuantity'])
            : value.quantity,
        "product": value.product['product'],
        "category": value.product['category'],
        "unit": value.product['unit'],
        "channel": channel,
        "date": stringDate,
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
      var currentShop = await SmartStockPosLocalStorage().getActiveShop();
      this.checkoutProgress = true;
      notifyListeners();
      String cartId = Security.generateUUID();
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
      //  this.checkoutProgress = false;
      // this.snack.open('Done save sales', 'Ok', {duration: 2000});
      // })
      // .catchError((reason){
      // this.checkoutProgress = false;
//    this.snack.open(
//    reason && reason.message ? reason.message : reason.toString(),
//    'Ok',
//    {duration: 3000}
//    );
      // });
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
          quantity: value.quantity,
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
}
