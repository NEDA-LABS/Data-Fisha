import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/stocks/components/index_summary.dart';
import 'package:smartstock/stocks/services/navigation.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

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
                              stocksSummary()
                            ])))),
            bottomNavigationBar: bottomBar(2, moduleMenus(), context)),
      );
}
