import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/dashboard/models/shop.dart';
import 'package:smartstock/modules/dashboard/states/shop-details.state.dart';
import 'package:smartstock/shared/componets/bottom-bar.shared.dart';
import 'package:smartstock/shared/componets/drawer.shared.dart';

import '../components/sales.component.dart';
import '../components/shop.component.dart';
import '../components/stock.component.dart';

class DashBoardPage extends BFastUIPage {
  @override
  Widget build(args) {
    return Scaffold(
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
//      drawer: Drawer(child: DrawerComponents().drawer),
      body: SafeArea(
        child: Center(
          child: ListView(
            children: <Widget>[
              DashboardShopComponents().currentShop,
              DashboardSalesComponents().performance,
              DashboardSalesComponents().grossProfit,
              DashboardStockComponents().health
            ],
          ),
        ),
      ),
      bottomNavigationBar: BFastUI.component()
          .custom((context) => BottomBarComponents().bottomBar(0)),
    );
  }
}
