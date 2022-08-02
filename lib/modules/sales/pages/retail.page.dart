import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';
import 'package:smartstock_pos/util.dart';

class RetailPage extends StatelessWidget {
  @override
  Widget build(var args) {
    // initiate products
    getState<SalesState>().getStockFromCache(productFilter: '');
    return Scaffold(
      appBar: SalesComponents().salesTopBar(title: "Retails", showSearch: true),
      floatingActionButton: SalesComponents().salesRefreshButton,
      body: SalesComponents().body(),
    );
  }
}
