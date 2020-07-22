import 'package:bfastui/adapters/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';

class CartState extends BFastUIState {
  final TextEditingController quantityInputController =
      TextEditingController(text: '1');
  final TextEditingController discountInputController =
      TextEditingController(text: '0');
  List<CartModel> cartProductsArray = [];
  CartModel currentCartModel;

  addStockToCart(CartModel cart) {
    CartModel updateItem = this.cartProductsArray.firstWhere(
        (x) => x.product['objectId'] == cart.product['objectId'],
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
        .indexWhere((element) => element.product['objectId'] == productId);
    if (indexOfProductInCart >= 0 &&
        this.cartProductsArray[indexOfProductInCart].quantity > 1) {
      this.cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity - 1;
      notifyListeners();
    }
  }

  void incrementQtyOfProductInCart(String productId) {
    int indexOfProductInCart = cartProductsArray
        .indexWhere((element) => element.product['objectId'] == productId);
    if (indexOfProductInCart >= 0) {
      cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity + 1;
      notifyListeners();
    }
  }

  void removeCart(CartModel cartModel) {
    this.cartProductsArray.retainWhere((element) =>
        element.product['objectId'] != cartModel.product['objectId']);
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

  @override
  void dispose() {
    quantityInputController.dispose();
    discountInputController.dispose();
    super.dispose();
  }
}
