import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  final List<Map<dynamic, int>> seriesList;
  final bool animate;

  const PieChart(this.seriesList, {super.key, this.animate = false});

  /// Creates a [PieChart] with sample data and no transition.
  factory PieChart.withSampleData() {
    return PieChart(
      _createSampleData(),
// Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return charts.PieChart(
    //   seriesList,
    //   animate: animate,
    //   // Add an [ArcLabelDecorator] configured to render labels outside of the
    //   // arc with a leader line.
    //   //
    //   // Text style for inside / outside can be controlled independently by
    //   // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
    //   //
    //   // Example configuring different styles for inside/outside:
    //   //       new charts.ArcLabelDecorator(
    //   //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
    //   //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
    //   // defaultRenderer: charts.ArcRendererConfig(
    //   //   arcRendererDecorators: [
    //   //     charts.ArcLabelDecorator(
    //   //         labelPosition: charts.ArcLabelPosition.outside)
    //   //   ],
    //   // ),
    // );
  }

  /// Create one series with sample hard coded data.
  static List<Map<LinearSales, int>> _createSampleData() {
    final data = [
      LinearSales(0, 100),
      LinearSales(1, 75),
      LinearSales(2, 25),
      LinearSales(3, 5),
    ];

    return [
//       Map<LinearSales, int>(
//         id: 'Sales',
//         domainFn: (LinearSales sales, _) => sales.year,
//         measureFn: (LinearSales sales, _) => sales.sales,
//         data: data,
// // Set a label accessor to control the text of the arc label.
//         labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
//       )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
