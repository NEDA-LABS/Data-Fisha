import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/index_page.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/switch_to_item.dart';
import 'package:smartstock/stocks/components/index_summary.dart';
import 'package:smartstock/stocks/services/navigation.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) => ResponsivePage(
        office: 'Menu',
        current: '/stock/',
        menus: moduleMenus(),
        sliverAppBar:
            StockAppBar(title: "Stocks", showBack: false, context: context),
        onBody: (_) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 790),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    switchToTitle(),
                    Wrap(
                      children: switchToItems(
                        stocksMenu()
                            .pages
                            .where((element) => element.name != 'Summary')
                            .toList(),
                      ),
                    ),
                    stocksSummary()
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
