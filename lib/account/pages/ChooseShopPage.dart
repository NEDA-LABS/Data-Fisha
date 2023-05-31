import 'package:flutter/material.dart';
import 'package:smartstock/account/components/ChooseShop.dart';
import 'package:smartstock/core/services/util.dart';

class ChooseShopPage extends StatelessWidget {
  final OnGetModulesMenu onGetModulesMenu;
  const ChooseShopPage({Key? key, required this.onGetModulesMenu}) : super(key: key);

  @override
  Widget build(var context) {
    return Scaffold(body: ChooseShop(onGetModulesMenu: onGetModulesMenu));
  }
}
