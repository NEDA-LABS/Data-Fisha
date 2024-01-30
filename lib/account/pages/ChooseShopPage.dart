import 'package:flutter/material.dart';
import 'package:smartstock/account/components/ChooseShop.dart';
import 'package:smartstock/core/pages/PageBase.dart';
import 'package:smartstock/core/helpers/util.dart';

class ChooseShopPage extends PageBase {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const ChooseShopPage({
    super.key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  }) : super(pageName: 'ChooseShopPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChooseShopPage> {
  @override
  Widget build(var context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ChooseShop(
        onGetModulesMenu: widget.onGetModulesMenu,
        onGetInitialModule: widget.onGetInitialModule,
      ),
    );
  }
}
