import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/top_bar.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';
import 'package:smartstock_pos/util.dart';

class CheckoutPage extends StatelessWidget {
  final args;

  CheckoutPage(this.args);

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
