import 'package:flutter/material.dart';
import 'package:smartstock_pos/common/util.dart';

import '../components/cart.component.dart';
import '../components/top_bar.dart';
import '../states/cart.state.dart';

class CheckoutPage extends StatelessWidget {
  final args;

  CheckoutPage(this.args);

  @override
  Widget build(var context) {
    bool wholesale =
        args != null && args.params != null && args.params['type'] == 'whole';
    getState<CartState>().discountInputController.text = '0';
    return Scaffold(
      appBar: salesTopBar(title: "Cart - ${wholesale ? 'Wholesale' : 'Retail'}"),
      body: CartComponents().cartView(wholesale: wholesale),
    );
  }
}
