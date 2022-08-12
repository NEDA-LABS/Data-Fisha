import 'package:flutter/material.dart';
import 'package:smartstock_pos/common/util.dart';

import '../components/sales_body.dart';
import '../components/stock_refresh_button.dart';
import '../components/top_bar.dart';
import '../states/sales.state.dart';

class RetailPage extends StatelessWidget {
  @override
  Widget build(var args) {
    // initiate products
    getState<SalesState>().getStockFromCache(productFilter: '');
    return Scaffold(
      appBar: salesTopBar(title: "Retails", showSearch: true),
      floatingActionButton: salesRefreshButton,
      body: saleBody(),
    );
  }
}
