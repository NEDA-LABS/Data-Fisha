import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
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
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 19),
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
                                                    fontSize: 25,
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
            ' Items = ${NumberFormat.currency(name: 'TZS ').format(state.getTotal(isWholesale: wholesale))}',
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    });
  }

  Widget cartView({bool wholesale = false}) {
    print(wholesale);
    return Container();
  }
}
