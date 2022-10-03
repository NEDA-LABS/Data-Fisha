import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  const BarChart(this.seriesList, {Key? key, required this.animate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      domainAxis: const charts.OrdinalAxisSpec(
          showAxisLine: false,
          renderSpec: charts.NoneRenderSpec()),
      // domainAxis: const charts.OrdinalAxisSpec(
      //   renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
      // ),
    );
  }
}
