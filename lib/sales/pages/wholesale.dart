import 'package:flutter/material.dart';

import '../components/refresh_button.dart';
import '../components/sales_body.dart';

class WholesalePage extends StatelessWidget {
  const WholesalePage({Key key}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      // appBar: salesTopBar(title: "Wholesale", showSearch: true),
      // floatingActionButton: salesRefreshButton,
      body: salesBody(wholesale: true),
    );
  }
}
