import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/dashboard/components/summary.dart';

class DashboardIndexPage extends PageBase {
  const DashboardIndexPage({super.key})
      : super(pageName: 'DashboardIndexPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardIndexPage> {
  @override
  Widget build(context) {
    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      office: 'Menu',
      current: '/dashboard/',
      sliverAppBar: SliverSmartStockAppBar(
          title: "Dashboard", showBack: false, context: context),
      staticChildren: const [DashboardSummary()],
    );
  }
}
