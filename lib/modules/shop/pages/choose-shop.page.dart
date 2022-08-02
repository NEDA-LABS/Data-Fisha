import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/shop/components/shop.component.dart';

class ChooseShopPage extends StatelessWidget {
  @override
  Widget build(var args) {
    return Scaffold(
      body: ShopComponents().chooseShop,
    );
  }
}
