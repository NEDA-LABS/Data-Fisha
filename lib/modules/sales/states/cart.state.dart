import 'package:bfastui/adapters/state.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';

class CartState extends BFastUIState {
  int cartItems = 0;
  int discount = 0;
  int totalCost = 0;
  List<CartModel> cartProductsArray = [];

  addStockToCart(CartModel cart) {
    CartModel updateItem = this
        .cartProductsArray
        .firstWhere((x) => x.product['objectId'] == cart.product['objectId']);
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

  calculateCartItems() {
    this.cartItems = this
        .cartProductsArray
        .map<int>((cartItem) => cartItem.quantity)
        .reduce((value, element) => value + element);
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
    notifyListeners();
    return totalCost;
  }

  void decrementQtyOfProductInCart(int indexOfProductInCart, {bool isWholesale = false}) {
    if (this.cartProductsArray[indexOfProductInCart].quantity > 1) {
      this.cartProductsArray[indexOfProductInCart].quantity =
          cartProductsArray[indexOfProductInCart].quantity - 1;
    }
    this.getTotal(isWholesale: isWholesale);
  }

  void incrementQtyOfProductInCart(int indexOfProductInCart, {bool isWholesale = false}) {
    cartProductsArray[indexOfProductInCart].quantity =
        cartProductsArray[indexOfProductInCart].quantity + 1;
    this.getTotal(isWholesale: isWholesale);
  }

  void removeCart(int indexOfProductInCart, {bool isWholesale = false}) {
    this.cartProductsArray.removeAt(indexOfProductInCart);
    getTotal(isWholesale: isWholesale);
  }

  int incrementQtyOfProductToBeAddedToCart(CartModel cart){

  }

  int decrementQtyOfProductToBeAddedToCart(CartModel cart){

  }
}
