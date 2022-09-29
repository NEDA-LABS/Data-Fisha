import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/bottom_bar.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/summary_report_card.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/stocks/services/stocks_report.dart';

class DashboardIndexPage extends StatelessWidget {
  const DashboardIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    return responsiveBody(
      office: 'Menu',
      current: '/dashboard/',
      menus: moduleMenus(),
      onBody: (d) => Scaffold(
        drawer: d,
        appBar: StockAppBar(title: "Dashboard", showBack: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 790),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Profit & Loss'),
                  _profitAndLoss(),
                  const Text('Cash sales'),
                  _cashSales(),
                  const Text('Invoices sales'),
                  _invoiceSales(),
                  const Text('Expenditure'),
                  _expenditures(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: bottomBar(0, moduleMenus(), context),
      ),
    );
  }

_profitAndLoss() {
  return Wrap(
    children: const [
      DashboardSummaryReportCard(
        title: 'Items',
        future: getTotalPositiveItems,
      ),
      DashboardSummaryReportCard(
        title: 'Items purchase value ( Tsh )',
        future: getItemsValue,
      )
    ],
  );
}

_cashSales() {
  return Wrap(
    children: const [],
  );
}

_invoiceSales() {
  return Wrap(
    children: const [],
  );
}

_expenditures() {
  return Wrap(
    children: const [],
  );
}
}
