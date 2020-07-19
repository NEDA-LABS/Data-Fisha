import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/app/login.state.dart';
import 'package:smartstock/modules/sales/components/retail.component.dart';
import 'package:smartstock/modules/sales/states/sales.state.dart';

class SalesComponents {
  AppBar salesTopBar({title = "Sales"}) {
    return AppBar(
      title: Text(title),
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
                      RetailComponents().showBottomSheet(
                        stock: salesState.stocks[index],
                        context: context,
                        wholesale: wholesale,
                      );
                    },
                    child: RetailComponents().productCardItem(
                        productCategory: salesState.stocks[index]['category'],
                        productName: salesState.stocks[index]['product'],
                        productPrice:
                            salesState.stocks[index]['retailPrice'].toString()),
                  ),
                );
              },
            ),
    );
  }
}
