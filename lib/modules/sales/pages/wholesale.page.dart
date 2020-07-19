import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/modules/sales/components/sales.component.dart';

class WholesalePage extends BFastUIPage {
  @override
  Widget build(var args) {
    return Scaffold(
      appBar: SalesComponents().salesTopBar(title: "Wholesale"),
      floatingActionButton: SalesComponents().salesRefreshButton,
      body: SalesComponents().listOfProducts(wholesale: true),
    );
  }
}
