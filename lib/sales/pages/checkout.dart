import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/sales/components/cart_drawer.dart';

import '../../core/services/util.dart';
import '../states/cart.dart';

class CheckoutPage extends StatelessWidget {
  final dynamic args;

  const CheckoutPage(this.args, {Key key}) : super(key: key);

  @override
  Widget build(var context) {
    bool wholesale =
        args != null && args.params != null && args.params['type'] == 'whole';
    getState<CartState>().discountInputController.text = '0';
    return Scaffold(
      appBar: StockAppBar(
          title: "Cart - ${wholesale ? 'Wholesale' : 'Retail'}",
          showBack: true,
          backLink: '/sales/${wholesale ? 'whole' : 'retail'}',
          showSearch: true,
          onSearch: (d) {},
          searchHint: 'Customer'),
      body: cartDrawer(carts: [], wholesale: false),
    );
  }
}
