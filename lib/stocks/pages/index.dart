import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/bottom_bar.dart';
import 'package:smartstock_pos/core/components/drawer.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/stocks/components/index_header.dart';
import 'package:smartstock_pos/stocks/components/index_summary.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  Widget build(context) {
    return Scaffold(
      drawer: drawer(officeName: 'Menu', menus: moduleMenus()),
      appBar: topBAr(title: "Stocks", showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        children: [stocksHeader(), stocksSummary()],
      ),
      bottomNavigationBar: bottomBar(2, moduleMenus(), context),
    );
  }
}
