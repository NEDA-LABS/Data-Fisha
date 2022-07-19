import 'package:bfastui/adapters/page.adapter.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';

class WholesalePage extends PageAdapter {
  @override
  Widget build(var args) {
    return Scaffold(
      appBar:
          SalesComponents().salesTopBar(title: "Wholesale", showSearch: true),
      floatingActionButton: SalesComponents().salesRefreshButton,
      body: SalesComponents().body(wholesale: true),
    );
  }
}
