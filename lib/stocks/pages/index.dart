import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/stock_summary.dart';

class StocksIndexPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const StocksIndexPage({
    super.key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(pageName: 'StocksIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StocksIndexPage> {
  @override
  Widget build(context) {
    var appBar = SliverSmartStockAppBar(
      title: "Product summaries",
      showBack: true,
      onSearch: (p0) {
        widget.onBackPage();
      },
      context: context,
    );
    return ResponsivePage(
      office: '',
      current: '/stock/',
      sliverAppBar: appBar,
      backgroundColor: Theme.of(context).colorScheme.surface,
      staticChildren: [
        StocksSummary(
            onBackPage: widget.onBackPage, onChangePage: widget.onChangePage)
      ],
    );
  }
}
