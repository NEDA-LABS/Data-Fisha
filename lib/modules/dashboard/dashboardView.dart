import 'package:flutter/material.dart';
import 'package:smartstock_flutter_mobile/shared/drawer.dart';
import 'current_shop.dart';
import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'sales_performance.dart';
import 'gross_profit_performance.dart';
import 'stock_health.dart';

class DashBoardView extends StatefulWidget {
  DashBoardView({Key key}) : super(key: key);

  @override
  _DashBoardViewState createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Show logout options"),
                ));
              },
            )
          ],
        ),
        drawer: DrawerPage(),
        body: SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                CurrentShop(shop: Shop(name: "Fish Genge")),
                SalesPerformance(shop: Shop(name: "Fish Genge")),
                GrossProfitPerformance(shop: Shop(name: "Fish Genge")),
                StockHealth(shop: Shop(name: "Fish Genge"))
              ],
            ),
          ),
        ));
  }
}
