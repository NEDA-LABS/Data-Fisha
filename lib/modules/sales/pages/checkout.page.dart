import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/components/cart.component.dart';
import 'package:smartstock_pos/modules/sales/components/sales.component.dart';

class CheckoutPage extends BFastUIPage {
  @override
  Widget build(var args) {
    print(args.params);
    return Scaffold(
      appBar: SalesComponents().salesTopBar(title: "Cart"),
      body: CartComponents().cartView(
          wholesale: args != null &&
              args.params != null &&
              args.params['type'] == 'whole'),
    );
  }
}
