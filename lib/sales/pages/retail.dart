import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../components/refresh_button.dart';
import '../components/sales_body.dart';
import '../components/top_bar.dart';
import '../states/sales.dart';

class RetailPage extends StatelessWidget {
  const RetailPage({Key key}) : super(key: key);

  @override
  Widget build(var context) {
    // initiate products
    getState<SalesState>().getStockFromCache(productFilter: '');
    return Scaffold(
      appBar: salesTopBar(title: "Retails", showSearch: true),
      floatingActionButton: salesRefreshButton,
      body: salesBody(wholesale: false),
    );
  }
}
