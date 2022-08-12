import 'package:flutter/material.dart';

import '../components/sales_body.dart';
import '../components/stock_refresh_button.dart';
import '../components/top_bar.dart';

class WholesalePage extends StatelessWidget {
  @override
  Widget build(var args) {
    return Scaffold(
      appBar: salesTopBar(title: "Wholesale", showSearch: true),
      floatingActionButton: salesRefreshButton,
      body: saleBody(wholesale: true),
    );
  }
}
