import 'package:flutter/material.dart';
import 'package:smartstock/account/components/ChooseShop.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';

class ChooseShopPage extends PageBase {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const ChooseShopPage({
    Key? key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  }) : super(key: key, pageName: 'ChooseShopPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChooseShopPage> {
  @override
  Widget build(var context) {
    return Scaffold(
      body: ChooseShop(
        onGetModulesMenu: widget.onGetModulesMenu,
        onGetInitialModule: widget.onGetInitialModule,
      ),
    );
  }
}
