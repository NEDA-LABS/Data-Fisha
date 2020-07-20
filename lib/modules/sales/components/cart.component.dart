import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';

class CartComponents {
  void addToCartSheet(
      {BuildContext context, CartModel cartModel, wholesale = false}) {
    Scaffold.of(context).showBottomSheet((context){
      return BFastUI.component().consumer<CartState>((context, state){
        return Container(
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
                        padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      cartModel.product["product"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 19),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Text(
                                        NumberFormat.currency(name: 'TZS ')
                                            .format(
                                          int.parse(
                                            cartModel.product[wholesale
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
//                            Expanded(
//                              child: FlatButton.icon(
//                                label: Text("Add To Cart"),
//                                icon: Icon(Icons.close),
//                                onPressed: () {},
//                              ),
//                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: Colors.green,
                            ),
                            onPressed: () {},
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white10,
                              ),
                              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                              width: MediaQuery.of(context).size.width * 0.9,
                              alignment: Alignment.center,
                              child: FormBuilderTextField(
                                autofocus: false,
                                maxLines: 1,
                                minLines: 1,
                                initialValue: cartModel.quantity.toString(),
                                onChanged: (value) {
                                  //  state.filterProducts(value);
                                },
                                attribute: 'quantity',
                                decoration: InputDecoration(
                                  hintText: "Enter quantity...",
                                  border: InputBorder.none,
//                suffixIcon: state.searchKeyword.isNotEmpty
//                    ? InkWell(
//                        child: Icon(Icons.clear),
//                        onTap: () {
//                          state.resetSearchKeyword('');
//                        },
//                      )
//                    : null,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {}),
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () {},
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
        );
      });
    });
  }
}
