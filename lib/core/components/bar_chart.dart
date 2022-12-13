import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final _compactFormatter =
      charts.BasicNumericTickFormatterSpec.fromNumberFormat(
          NumberFormat.compactSimpleCurrency(name: ''));

  BarChart(this.seriesList, {Key? key, required this.animate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      domainAxis: const charts.OrdinalAxisSpec(
        showAxisLine: false,
        renderSpec: charts.NoneRenderSpec(),
      ),
      primaryMeasureAxis:
          charts.NumericAxisSpec(tickFormatterSpec: _compactFormatter),
      behaviors: [
        // charts.LinePointHighlighter(
        //   showHorizontalFollowLine:
        //       charts.LinePointHighlighterFollowLineType.none,
        //   showVerticalFollowLine:
        //       charts.LinePointHighlighterFollowLineType.nearest,
        // ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
        // charts.SeriesLegend()
      ],
      // barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }
}
