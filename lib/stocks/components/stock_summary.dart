import 'package:flutter/widgets.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/summary_report_card.dart';
import 'package:smartstock/stocks/services/stocks_report.dart';

class StocksSummary extends StatefulWidget {
  const StocksSummary({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StocksSummary> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_title(), _reports()]);
  }

  _title() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: TitleLarge(text: "Summary"),
    );
  }

  _reports() {
    return Wrap(
      children: const [
        DashboardSummaryReportCard(
          title: 'Items quantity',
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
  }
}
