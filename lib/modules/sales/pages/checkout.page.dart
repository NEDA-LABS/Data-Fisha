import 'package:bfastui/adapters/page.adapter.dart';
import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';
import 'package:smartstock_pos/modules/sales/states/cart.state.dart';

class CheckoutPage extends PageAdapter {
  @override
  Widget build(var args) {
    bool wholesale =
        args != null && args.params != null && args.params['type'] == 'whole';
    BFastUI.getState<CartState>().discountInputController.text = '0';
    return Scaffold(
      appBar: SalesComponents()
          .salesTopBar(title: "Cart - ${wholesale ? 'Wholesale' : 'Retail'}"),
      body: CartComponents().cartView(wholesale: wholesale),
    );
  }
}
