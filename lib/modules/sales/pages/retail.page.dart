import 'package:bfastui/adapters/page.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';

class RetailPage extends PageAdapter {
  @override
  Widget build(var args) {
    // initiate products
    BFastUI.getState<SalesState>().getStockFromCache();
    return BFastUI.component().custom((_) {
      return Scaffold(
        appBar:
            SalesComponents().salesTopBar(title: "Retails", showSearch: true),
        floatingActionButton: SalesComponents().salesRefreshButton,
        body: SalesComponents().body(),
      );
    });
  }
}
