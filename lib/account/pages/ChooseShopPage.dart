import 'package:flutter/material.dart';
import 'package:smartstock/account/components/ChooseShop.dart';
import 'package:smartstock/core/services/util.dart';

class ChooseShopPage extends StatelessWidget {
  final OnDoneSelectShop onDoneSelectShop;
  const ChooseShopPage({Key? key, required this.onDoneSelectShop}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(body: ChooseShop(onDoneSelectShop: onDoneSelectShop,));
  }
}
