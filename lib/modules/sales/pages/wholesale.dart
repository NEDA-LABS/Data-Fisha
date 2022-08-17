import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/refresh_button.dart';
import 'package:smartstock_pos/modules/sales/components/sales_body.dart';
import 'package:smartstock_pos/modules/sales/components/top_bar.dart';

class WholesalePage extends StatelessWidget {
  @override
  Widget build(var args) {
    return Scaffold(
      appBar: salesTopBar(title: "Wholesale", showSearch: true),
      floatingActionButton: salesRefreshButton,
      body: salesBody(wholesale: true),
    );
  }
}
