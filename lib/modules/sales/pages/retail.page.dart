import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/controllers/state.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class RetailPage extends PageAdapter {
  @override
  Widget build(var args) {
    // initiate products
    getState<SalesState>().getStockFromCache(productFilter: '');
    return Scaffold(
      appBar:
      SalesComponents().salesTopBar(title: "Retails", showSearch: true),
      floatingActionButton: SalesComponents().salesRefreshButton,
      body: SalesComponents().body(),
    );
  }
}
