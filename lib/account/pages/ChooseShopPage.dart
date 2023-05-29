import 'package:flutter/material.dart';
import 'package:smartstock/account/components/ChooseShop.dart';

class ChooseShopPage extends StatelessWidget {
  final Function() onDoneSelectShop;
  const ChooseShopPage({Key? key, required this.onDoneSelectShop}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(body: ChooseShop(onDoneSelectShop: onDoneSelectShop,));
  }
}
