import 'package:flutter/material.dart';
import 'package:smartstock/dashboard/components/numberCard.dart';

class DashboardSummaryReportCard extends StatefulWidget {
  final String title;
  final dynamic future;

  const DashboardSummaryReportCard({
    required this.title,
    required this.future,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardSummaryReportCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loading(context);
        }
        return NumberPercentageCard(
          widget.title,
          snapshot.hasData ? snapshot.data : 0,
          0,
        );
      },
      future: widget.future(),
    );
  }

  _loading(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
  }
}
