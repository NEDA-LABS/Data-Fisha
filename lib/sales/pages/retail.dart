import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/refresh_button.dart';
import 'package:smartstock_pos/modules/sales/components/sales_body.dart';
import 'package:smartstock_pos/modules/sales/components/top_bar.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';
import 'package:smartstock_pos/util.dart';

class RetailPage extends StatelessWidget {
  @override
  Widget build(var args) {
    // initiate products
    getState<SalesState>().getStockFromCache(productFilter: '');
    return Scaffold(
      appBar: salesTopBar(title: "Retails", showSearch: true),
      floatingActionButton: salesRefreshButton,
      body: salesBody(wholesale: false),
    );
  }
}
