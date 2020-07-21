import 'package:bfastui/adapters/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';

class CartState extends BFastUIState {
  final TextEditingController quantityInputController =
  TextEditingController(text: '1');
  int cartItems = 0;
  int discount = 0;
  int totalCost = 0;
  List<CartModel> cartProductsArray = [];
  CartModel currentCartModel;


  addStockToCart(CartModel cart) {
    CartModel updateItem = this
        .cartProductsArray
        .firstWhere((x) => x.product['objectId'] == cart.product['objectId'], orElse: ()=>null);
    if (updateItem != null) {
      var index = this.cartProductsArray.indexOf(updateItem);
      this.cartProductsArray[index].quantity =
          this.cartProductsArray[index].quantity + cart.quantity;
    } else {
      this.cartProductsArray.add(cart);
    }
    calculateCartItems();
    this.getTotal();
    notifyListeners();
  }

  int calculateCartItems() {
    this.cartItems = this
        .cartProductsArray
        .map<int>((cartItem) => cartItem.quantity)
        .reduce((value, element) => value + element);
   // notifyListeners();
    return this.cartItems;
  }

  int getTotal({bool isWholesale = false}) {
    this.totalCost = this
            .cartProductsArray
            .map<int>((value) =>
                value.quantity *
                (isWholesale
                    ? value.product['wholesalePrice']
                    : value.product['retailPrice']))
            .reduce((a, b) => a + b) -
        this.discount;
   // notifyListeners();
    return totalCost;
  }

  void decrementQtyOfProductInCart(int indexOfProductInCart,
      {bool isWholesale = false}) {
    if (this.cartProductsArray[indexOfProductInCart].quantity > 1) {
      this.cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity - 1;
    }
    this.getTotal(isWholesale: isWholesale);
  }

  void incrementQtyOfProductInCart(int indexOfProductInCart,
      {bool isWholesale = false}) {
    cartProductsArray[indexOfProductInCart].quantity =
        cartProductsArray[indexOfProductInCart].quantity + 1;
    this.getTotal(isWholesale: isWholesale);
  }

  void removeCart(int indexOfProductInCart, {bool isWholesale = false}) {
    this.cartProductsArray.removeAt(indexOfProductInCart);
    getTotal(isWholesale: isWholesale);
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
    super.dispose();
  }
}
