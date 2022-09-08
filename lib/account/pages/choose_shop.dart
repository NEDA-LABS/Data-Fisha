import 'package:flutter/material.dart';
import 'package:smartstock/account/components/choose_shop.dart';


class ChooseShopPage extends StatelessWidget {
  const ChooseShopPage({Key key}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(
      body: ShopComponents().chooseShop,
    );
  }
}
