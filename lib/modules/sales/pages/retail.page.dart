import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/page.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/modules/sales/components/sales.component.dart';
import 'package:smartstock/modules/sales/states/sales.state.dart';

class RetailPage extends BFastUIPage {
  @override
  Widget build(var args) {
    // initiate products
    BFastUI.getState<SalesState>().getStockFromCache();
    return BFastUI.component().custom((_) {
      return Scaffold(
        appBar: SalesComponents().salesTopBar(title: "Retails"),
        floatingActionButton: SalesComponents().salesRefreshButton,
        body: SalesComponents().listOfProducts(),
      );
    });
  }
}
