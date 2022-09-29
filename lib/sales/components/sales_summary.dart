import 'package:flutter/widgets.dart';
import 'package:smartstock/core/components/summary_report_card.dart';
import 'package:smartstock/stocks/services/stocks_report.dart';

_title() => const Padding(
    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
    child: Text("Summary",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)));

_reports() => Wrap(
  children: [
    DashboardSummaryReportCard(
      title: 'Sales',
      future: getTotalPositiveItems,
    ),
    DashboardSummaryReportCard(
      title: 'Items purchase value ( Tsh )',
      future: getItemsValue,
    ),
    DashboardSummaryReportCard(
      title: 'Items retail value ( Tsh )',
      future: getItemsRetailValue,
    ),
    DashboardSummaryReportCard(
      title: 'Items wholesale value ( Tsh )',
      future: getItemsWholesaleValue,
    )
  ],
);

salesSummary() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_title(), _reports()]);
