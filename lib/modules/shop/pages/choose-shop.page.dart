import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/modules/shop/components/shop.component.dart';

class ChooseShopPage extends BFastUIPage {
  @override
  Widget build(var args) {
    return Scaffold(
      body: ShopComponents().chooseShop,
    );
  }
}
