/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final _compactFormatter =
      charts.BasicNumericTickFormatterSpec.fromNumberFormat(
          NumberFormat.compactSimpleCurrency(name: ''));

  TimeSeriesChart(this.seriesList, {Key? key, this.animate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis:
          charts.NumericAxisSpec(tickFormatterSpec: _compactFormatter),
      behaviors: [
        charts.LinePointHighlighter(
          showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.none,
          showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest,
        ),
        charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
        charts.SeriesLegend()
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}
