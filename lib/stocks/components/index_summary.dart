import 'package:flutter/widgets.dart';
import 'package:smartstock_pos/core/components/summary_report_card.dart';
import 'package:smartstock_pos/stocks/services/stocks_report.dart';

_title() => const Padding(
    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
    child: Text("Summary",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)));

_reports() => Wrap(
      children: [
        numberSummaryReportCard(
          title: 'Items',
          future: getTotalPositiveItems,
        ),
        numberSummaryReportCard(
          title: 'Items purchase value ( Tsh )',
          future: getItemsValue,
        ),
        numberSummaryReportCard(
          title: 'Items retail value ( Tsh )',
          future: getItemsRetailValue,
        ),
        numberSummaryReportCard(
          title: 'Items wholesale value ( Tsh )',
          future: getItemsWholesaleValue,
        )
      ],
    );

stocksSummary() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_title(), _reports()]);
