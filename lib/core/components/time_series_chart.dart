
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSeriesChart extends StatelessWidget {
  final List<Map<dynamic, DateTime>> seriesList;
  final bool animate;
  final _compactFormatter = NumberFormat.compactSimpleCurrency(name: '');

  TimeSeriesChart(this.seriesList, {super.key, this.animate = true});

  @override
  Widget build(BuildContext context) {
    return Container();
    // return charts.TimeSeriesChart(
    //   seriesList,
    //   animate: animate,
    //   primaryMeasureAxis:
    //       charts.NumericAxisSpec(tickFormatterSpec: _compactFormatter),
    //   behaviors: [
    //     charts.LinePointHighlighter(
    //       showHorizontalFollowLine:
    //           charts.LinePointHighlighterFollowLineType.none,
    //       showVerticalFollowLine:
    //           charts.LinePointHighlighterFollowLineType.nearest,
    //     ),
    //     charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
    //     charts.SeriesLegend()
    //   ],
    //   dateTimeFactory: const charts.LocalDateTimeFactory(),
    // );
  }
}
