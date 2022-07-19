import 'package:bfastui/adapters/page.adapter.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/shop/components/shop.component.dart';

class ChooseShopPage extends PageAdapter {
  @override
  Widget build(var args) {
    return Scaffold(
      body: ShopComponents().chooseShop,
    );
  }
}
