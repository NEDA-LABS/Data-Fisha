import 'package:bfastui/controllers/component.dart';
import 'package:bfastui/controllers/navigation.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smartstock_pos/modules/app/states/login.state.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/retail.component.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesComponents {
  PreferredSizeWidget get _searchInput {
    return PreferredSize(
        child: consumerComponent<SalesState>(
          builder: (context, state) => Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white70,
            ),
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            width: MediaQuery.of(context).size.width * 0.9,
            alignment: Alignment.center,
            child: FormBuilderTextField(
              autofocus: false,
              maxLines: 1,
              // controller: state.searchInputController,
              minLines: 1,
              initialValue: state.searchKeyword,
              onChanged: (value) {
                state.filterProducts(value ?? '');
              },
              name: 'query',
              decoration: InputDecoration(
                hintText: "Enter a keyword...",
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
        preferredSize: Size.fromHeight(52));
  }

  AppBar salesTopBar({title = "Sales", showSearch = false}) {
    return AppBar(
      title: Text(title),
      bottom: showSearch ? this._searchInput : null,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          if (title == 'Sales') {
            navigateTo('/shop');
          } else {
            navigateTo("/sales");
          }
        },
      ),
      actions: <Widget>[
        Builder(
          builder: (context) => PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                child: FlatButton(
                  onPressed: () {
                    getState<LoginPageState>().logOut();
                  },
                  child: Row(
                    children: [
                      Text("Logout"),
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).primaryColorDark,
                      )
                    ],
                  ),
                ),
              ),
            ],
            icon: Icon(Icons.account_circle),
          ),
        ),
      ],
    );
  }

  Widget get salesRefreshButton {
    return consumerComponent<SalesState>(
      builder: (context, salesState) => !salesState.loadProductsProgress
          ? consumerComponent<CartState>(builder: (context, cartState) {
              return cartState.currentCartModel != null
                  ? FloatingActionButton(
                      child: Icon(Icons.close),
                      onPressed: () {
                        getState<CartState>().setCurrentCartToBeAdded(null);
                        Navigator.pop(context);
                      },
                    )
                  : cartState.cartProductsArray.length <= 0
                      ? FloatingActionButton(
                          child: Icon(Icons.refresh),
                          onPressed: () {
                            salesState.getStockFromRemote();
                          },
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        );
            })
          : Container(),
    );
  }

  Widget get _showProductLoading {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/data.png',
              height: 150,
              width: 150,
            ),
            CircularProgressIndicator(),
            Container(
              height: 20,
            ),
            Text(
              "Fetching products",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  Widget listOfProducts({wholesale = false}) => consumerComponent<SalesState>(
        builder: (context, salesState) => salesState.loadProductsProgress
            ? this._showProductLoading
            : GridView.builder(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                itemCount: salesState.stocks.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          getState<CartState>()
                              .setCurrentCartToBeAdded(CartModel(
                            product: salesState.stocks[index],
                            quantity: 1,
                          ));
                          CartComponents().addToCartSheet(
                            context: context,
                            wholesale: wholesale,
                          );
                        },
                        child: RetailComponents().productCardItem(
                            productCategory:
                                salesState.stocks[index]['category'].toString(),
                            productName:
                                salesState.stocks[index]['product'].toString(),
                            productPrice: salesState.stocks[index]
                                [wholesale ? "wholesalePrice" : 'retailPrice']),
                      );
                    },
                  );
                },
              ),
      );

  Widget body({bool wholesale = false}) => Stack(
        children: [
          Positioned(
            child: this.listOfProducts(wholesale: wholesale),
            bottom: 0,
            right: 0,
            left: 0,
            top: 0,
          ),
          Positioned(
            child: consumerComponent<CartState>(
              builder: (context, cartState) =>
                  cartState.cartProductsArray.length > 0
                      ? CartComponents().cartPreview(wholesale: wholesale)
                      : Container(
                          height: 0,
                          width: 0,
                        ),
            ),
            bottom: 16,
            left: 16,
            right: 16,
          )
        ],
      );
}
