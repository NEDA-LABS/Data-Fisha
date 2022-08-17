import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/bottom_bar.dart';
import 'package:smartstock_pos/core/components/drawer.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      drawer: drawer(officeName: 'Menu', menus: moduleMenus()),
      appBar: topBAr(title: "Stocks", showBack: false),
      body: Container(),
      bottomNavigationBar: bottomBar(2, moduleMenus(), context),
    );
  }
}
