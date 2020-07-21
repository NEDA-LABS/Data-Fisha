import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smartstock_pos/modules/app/login.state.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/retail.component.dart';
import 'package:smartstock_pos/modules/sales/models/cart.model.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class SalesComponents {
  PreferredSizeWidget get _searchInput {
    return PreferredSize(
        child: BFastUI.component().consumer<SalesState>(
          (context, state) => Container(
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
              //  controller: state.searchInputController,
              minLines: 1,
              initialValue: state.searchKeyword,
              onChanged: (value) {
                state.filterProducts(value);
              },
              attribute: 'query',
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
      actions: <Widget>[
        BFastUI.component().custom(
          (context) => PopupMenuButton(
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                child: FlatButton(
                  onPressed: () {
                    BFastUI.getState<LoginPageState>().logOut();
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
    return BFastUI.component().consumer<SalesState>(
      (context, state) => !state.loadProductsProgress
          ? FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                BFastUI.getState<SalesState>().getStockFromRemote();
              },
            )
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

  Widget listOfProducts({wholesale = false}) {
    return BFastUI.component().consumer<SalesState>(
      (context, salesState) => salesState.loadProductsProgress
          ? this._showProductLoading
          : GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: salesState.stocks.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return BFastUI.component().custom(
                  (context) => GestureDetector(
                    onTap: () {
                      CartComponents().addToCartSheet(
                        cartModel: CartModel(
                          product: salesState.stocks[index],
                          quantity: 1,
                        ),
                        context: context,
                        wholesale: wholesale,
                      );
                    },
                    child: RetailComponents().productCardItem(
                        productCategory: salesState.stocks[index]['category'],
                        productName: salesState.stocks[index]['product'],
                        productPrice: salesState.stocks[index]
                                [wholesale ? "wholesalePrice" : 'retailPrice']
                            .toString()),
                  ),
                );
              },
            ),
    );
  }
}
