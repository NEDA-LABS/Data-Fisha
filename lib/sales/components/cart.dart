import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/util.dart';
import '../models/cart.model.dart';
import '../states/cart.dart';

void addToCartSheet({BuildContext context, wholesale = false}) {
  Scaffold.of(context)
      .showBottomSheet((context) {
        return consumerComponent<CartState>(
          builder: (context, state) {
            return state.currentCartModel != null
                ? Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    height: 300,
                    child: Card(
                      elevation: 0,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 16, 10, 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                state.currentCartModel
                                                    ?.product["product"],
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: const Text(
                                                  '',
                                                  // NumberFormat.currency(
                                                  //         name: 'TZS ')
                                                  //     .format(
                                                  //   int.parse(
                                                  //     state
                                                  //         .currentCartModel
                                                  //         .product[wholesale
                                                  //             ? "wholesalePrice"
                                                  //             : "retailPrice"]
                                                  //         .toString(),
                                                  //   ),
                                                  // ),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // IconButton(
                                //   icon: Icon(
                                //     Icons.remove_circle,
                                //     color: Theme.of(context).primaryColorDark,
                                //   ),
                                //   onPressed: () {
                                //     state
                                //         .decrementQtyOfProductToBeAddedToCart();
                                //   },
                                // ),
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  height: 54,
                                  width: MediaQuery.of(context).size.width > 200
                                      ? 200
                                      : MediaQuery.of(context).size.width * 0.9,
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    autofocus: false,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    minLines: 1,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                        state.setCartQuantity(value),
                                    decoration: const InputDecoration(
                                      hintText: "Enter quantity...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                // IconButton(
                                //     icon: Icon(
                                //       Icons.add_circle,
                                //       color: Theme.of(context).primaryColorDark,
                                //     ),
                                //     onPressed: () => state
                                //         .incrementQtyOfProductToBeAddedToCart()),
                              ],
                            )),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    state
                                        .addStockToCart(state.currentCartModel);
                                    state.setCurrentCartToBeAdded(null);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 48,
                                    child: const Center(
                                      child: Text(
                                        "Add To Cart",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  );
          },
        );
      })
      .closed
      .then((value) => getState<CartState>().setCurrentCartToBeAdded(null))
      .catchError((_) {});
}

Widget cartView({bool wholesale = false}) {
  return Container(
    child: Column(
      children: [
        consumerComponent<CartState>(
          builder: (context, cartState) => Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: cartState.cartProductsArray.length,
              itemBuilder: (context, index) => _checkoutCartItem(
                cart: cartState.cartProductsArray[index],
                wholesale: wholesale,
                context: context,
              ),
            ),
          ),
        ),
        _cartSummary(wholesale: wholesale),
      ],
    ),
  );
}

Widget _cartSummary({bool wholesale}) => Card(
      elevation: 5,
      child: Column(
        children: [
          consumerComponent<CartState>(
            builder: (context, cartState) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text("Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    NumberFormat.currency(name: 'TZS ').format(
                      cartState.getTotalWithoutDiscount(isWholesale: wholesale),
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text('Discount ( TZS )'),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  height: 38,
                  width: 150,
                  alignment: Alignment.center,
                  child: TextField(
                    autofocus: false,
                    maxLines: 1,
                    minLines: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        getState<CartState>().setCartDiscount(value),
                    decoration: const InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          consumerComponent<CartState>(
              builder: (context, cartState) => Container(
                    margin: const EdgeInsets.all(8),
                    height: 54,
                    color: Theme.of(context).primaryColorDark,
                    child: cartState.checkoutProgress
                        ? Container(
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : TextButton(
                            // splashColor: Colors.grey,
                            onPressed: () {
                              cartState.checkout(wholesale: wholesale).catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Fail to checkout, please retry"),
                                  ),
                                );
                              });
                            },
                            child: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Checkout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  NumberFormat.currency(name: 'TZS ')
                                      .format(cartState.getFinalTotal(isWholesale: wholesale)),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                )
                              ],
                            ),
                          ),
                  ))
        ],
      ),
    );

Widget _checkoutCartItem(
        {CartModel cart, bool wholesale, BuildContext context}) =>
    Column(
      children: [
        ListTile(
          title: Text(cart.product['product']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wholesale
                  ? Text(
                      '${cart.quantity} (x${cart.product['wholesaleQuantity']}) ${cart.product['unit']}')
                  // ' @${NumberFormat.currency(name: 'TZS ').format(cart.product['wholesalePrice'])}')
                  : Text('${cart.quantity} ${cart.product['unit']} '
                      '@ ${NumberFormat.currency(name: 'TZS ').format(_amount(cart, wholesale))}'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => getState<CartState>()
                        .decrementQtyOfProductInCart(cart.product['id']),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => getState<CartState>()
                        .incrementQtyOfProductInCart(cart.product['id']),
                  ),
                ],
              )
            ],
          ),
          isThreeLine: false,
          trailing: IconButton(
            color: Colors.red,
            icon: const Icon(Icons.delete),
            onPressed: () => getState<CartState>().removeCart(cart, wholesale),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Divider(color: Colors.grey),
        )
      ],
    );

_amount(cart, bool wholesale) {
  return wholesale
      ? cart.product['wholesalePrice']
      : cart.product['retailPrice'];
}
