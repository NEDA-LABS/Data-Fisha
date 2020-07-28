import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';

class CartComponents {
  void addToCartSheet({BuildContext context, wholesale = false}) {
    Scaffold.of(context)
        .showBottomSheet((context) {
          return BFastUI.component().consumer<CartState>((context, state) {
            return state.currentCartModel != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
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
                                                    .product["product"],
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Text(
                                                  NumberFormat.currency(
                                                          name: 'TZS ')
                                                      .format(
                                                    int.parse(
                                                      state
                                                          .currentCartModel
                                                          .product[wholesale
                                                              ? "wholesalePrice"
                                                              : "retailPrice"]
                                                          .toString(),
                                                    ),
                                                  ),
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
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle,
                                    size: 36,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    state
                                        .decrementQtyOfProductToBeAddedToCart();
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                                    controller: BFastUI.getState<CartState>()
                                        .quantityInputController,
                                    onChanged: (value) {
                                      state.setCartQuantity(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Enter quantity...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.add_circle,
                                      size: 36,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      state
                                          .incrementQtyOfProductToBeAddedToCart();
                                    }),
                              ],
                            )),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                                    child: Center(
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
                    height: 300,
                  )
                : Container(
                    height: 0,
                  );
          });
        })
        .closed
        .then((value) {
          BFastUI.getState<CartState>().setCurrentCartToBeAdded(null);
        })
        .catchError((_) {});
  }

  Widget cartPreview({bool wholesale = false}) {
    return BFastUI.component().consumer<CartState>((context, state) {
      return FlatButton(
        onPressed: () {
          BFastUI.navigateTo(
              '/sales/checkout/${wholesale ? 'whole' : 'retail'}');
        },
        child: Container(
          height: 54,
          alignment: Alignment.center,
//        width: 300,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            '${state.calculateCartItems()}'
            ' Items = ${NumberFormat.currency(name: 'TZS ').format(state.getFinalTotal(isWholesale: wholesale))}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    });
  }

  Widget cartView({bool wholesale = false}) {
    return Container(
      child: Column(
        children: [
          BFastUI.component().consumer<CartState>(
            (context, cartState) => Expanded(
                child: ListView(
                  children: cartState.cartProductsArray.length > 0
                      ? cartState.cartProductsArray
                          .map(
                            (cart) => Column(
                              children: [
                                ListTile(
                                  title: Text(cart.product['product']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      wholesale
                                          ? Text(
                                              '${cart.quantity} (x${cart.product['wholesaleQuantity']}) ${cart.product['unit']}'
                                              ' @${NumberFormat.currency(name: 'TZS ').format(cart.product['wholesalePrice'])}')
                                          : Text(
                                              '${cart.quantity} ${cart.product['unit']}'
                                              ' @${NumberFormat.currency(name: 'TZS ').format(cart.product['retailPrice'])}'),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove_circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              cartState
                                                  .decrementQtyOfProductInCart(
                                                      cart.product['objectId']);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              cartState
                                                  .incrementQtyOfProductInCart(
                                                      cart.product['objectId']);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  isThreeLine: false,
                                  trailing: IconButton(
                                    color: Colors.red,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      cartState.removeCart(cart);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          )
                          .toList()
                      : [
                          Container(
                            child: Text('No item in cart'),
                          )
                        ],
                ),
                flex: 1),
          ),
          Card(
            child: Container(
              child: Column(
                children: [
                  BFastUI.component()
                      .consumer<CartState>((context, cartState) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  flex: 1,
                                ),
                                Text(
                                  NumberFormat.currency(name: 'TZS ').format(
                                    cartState.getTotalWithoutDiscount(
                                        isWholesale: wholesale),
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Discount ( TZS )'),
                          flex: 1,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(),
                          ),
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                          // height: 54,
                          width: 150,
                          alignment: Alignment.center,
                          child: TextFormField(
                            autofocus: false,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minLines: 1,
                            keyboardType: TextInputType.number,
                            controller: BFastUI.getState<CartState>()
                                .discountInputController,
                            onChanged: (value) {
                              BFastUI.getState<CartState>()
                                  .setCartDiscount(value);
                            },
                            decoration: InputDecoration(
                              hintText: "Press here...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BFastUI.component()
                      .consumer<CartState>((context, cartState) => Container(
                            margin: EdgeInsets.all(8),
                            height: 54,
                            color: Theme.of(context).primaryColorDark,
                            child: cartState.checkoutProgress
                                ? Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : FlatButton(
                                    splashColor: Colors.grey,
                                    onPressed: () {
                                      cartState.checkout().catchError((e) {
                                        Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Fail to checkout, please retry"),
                                          ),
                                        );
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Checkout',
                                            style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          flex: 1,
                                        ),
                                        Text(
                                          '${NumberFormat.currency(name: 'TZS ').format(cartState.getFinalTotal(isWholesale: wholesale))}',
                                          style: TextStyle(
                                            fontSize: 19,
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
            ),
            elevation: 5,
          ),
        ],
      ),
    );
  }
}
