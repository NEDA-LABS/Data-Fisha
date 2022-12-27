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
        staticChildren: [
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
      );
}
