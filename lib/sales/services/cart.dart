import 'package:bfast/util.dart';
import 'package:smartstock_pos/sales/models/cart.model.dart';

addToCarts(List<CartModel> carts, CartModel cart) {
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
  return updateOrAppend(index);
}
