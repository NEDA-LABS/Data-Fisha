import 'package:flutter/material.dart';
import 'package:smartstock_pos/app.dart';
import 'package:smartstock_pos/core/components/bottom_bar.dart';
import 'package:smartstock_pos/core/components/responsive_body.dart';
import 'package:smartstock_pos/core/components/top_bar.dart';
import 'package:smartstock_pos/stocks/components/index_summary.dart';

import '../../core/components/index_page.dart';
import '../../core/components/switch_to_item.dart';
import '../services/navigation.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key key}) : super(key: key);

  @override
  Widget build(context) => responsiveBody(
        office: 'Menu',
        current: '/stock/',
        menus: moduleMenus(),
        onBody: (d) => Scaffold(
          drawer: d,
          appBar: StockAppBar(title: "Stocks", showBack: false),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 790),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    switchToTitle(),
                    Wrap(children: switchToItems(stocksMenu().pages)),
                    stocksSummary(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomBar(2, moduleMenus(), context),
        ),
      );
}
