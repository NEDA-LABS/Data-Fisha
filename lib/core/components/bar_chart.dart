import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChart extends StatelessWidget {
  final List<Map<dynamic, String>> seriesList;
  final bool animate;
  final _compactFormatter = NumberFormat.compactSimpleCurrency(name: '');

  BarChart(this.seriesList, {super.key, required this.animate});

  @override
  Widget build(BuildContext context) {
    return Container();
    // return charts.BarChart(
    //   seriesList,
    //   animate: animate,
    //   domainAxis: const charts.OrdinalAxisSpec(
    //     showAxisLine: false,
    //     renderSpec: charts.NoneRenderSpec(),
    //   ),
    //   primaryMeasureAxis:
    //       charts.NumericAxisSpec(tickFormatterSpec: _compactFormatter),
    //   behaviors: [
    //     // charts.LinePointHighlighter(
    //     //   showHorizontalFollowLine:
    //     //       charts.LinePointHighlighterFollowLineType.none,
    //     //   showVerticalFollowLine:
    //     //       charts.LinePointHighlighterFollowLineType.nearest,
    //     // ),
    //     charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
    //     // charts.SeriesLegend()
    //   ],
    //   // barRendererDecorator: charts.BarLabelDecorator<String>(),
    // );
  }
}
