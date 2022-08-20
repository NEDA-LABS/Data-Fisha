import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../components/cart.dart';
import '../components/top_bar.dart';
import '../states/cart.dart';

class CheckoutPage extends StatelessWidget {
  final dynamic args;

  const CheckoutPage(this.args,{Key key}): super(key: key);

  @override
  Widget build(var context) {
    bool wholesale =
        args != null && args.params != null && args.params['type'] == 'whole';
    getState<CartState>().discountInputController.text = '0';
    return Scaffold(
      appBar:
          salesTopBar(title: "Cart - ${wholesale ? 'Wholesale' : 'Retail'}"),
      body: cartView(wholesale: wholesale),
    );
  }
}
