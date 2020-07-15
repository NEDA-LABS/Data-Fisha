import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/models/shop.dart';
import 'package:smartstock/shared/drawer.dart';
import 'package:smartstock/states/shop_details.dart';

import 'current-shop.component.dart';
import 'gross-profit-performance.component.dart';
import 'sales-performance.component.dart';
import 'stock-health.component.dart';

class DashBoardPage extends BFastUIPage {
  @override
  Widget build(args) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {
            BFastUI.states()
                .get<ShopDetailsState>()
                .addShop(newShop: new Shop(name: "Demo Shop"));
          },
        ),
        appBar: AppBar(
          title: Text("Dashboard"),
          actions: <Widget>[
            BFastUI.component().custom(
              (context) => IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Show logout options"),
                  ));
                },
              ),
            ),
          ],
        ),
        // todo: drawer is not working, must be fixed
        drawer: Drawer(child: DrawerComponents().drawer),
        body: SafeArea(
          child: Center(
            child: ListView(
              children: <Widget>[
                CurrentShopComponents().currentShop,
                SalesPerformanceComponents().performance,
                GrossProfitPerformanceComponents().grossProfit,
                StockHealthComponents().health
              ],
            ),
          ),
        ));
  }
}
