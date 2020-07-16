import 'package:bfastui/bfastui.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:smartstock/shared/componets/card-view.shared.dart';

class DashboardStockComponents {
  static var data = [
    new StockPerOutlet('Total', 12, Colors.red),
    new StockPerOutlet('Out', 20, Colors.yellow),
    new StockPerOutlet('Order', 100, Colors.green),
  ];

  static var series = [
    new charts.Series(
      id: 'StockPerOutlet',
      domainFn: (StockPerOutlet stockData, _) => stockData.outlet,
      measureFn: (StockPerOutlet stockData, _) => stockData.stockQuantity,
      colorFn: (StockPerOutlet stockData, _) => stockData.color,
      data: data,
    ),
  ];

  var chart = new charts.BarChart(
    series,
    animate: true,
  );

  Widget get health {
    return BFastUI.component().custom((context) {
      return CardView(cardItems: <Widget>[
        Spacer(),
        Row(
          children: <Widget>[
            Spacer(),
            Text("Stock Health"),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "What is the distribution of your stock per category?"),
                ));
              },
            ),
            Spacer()
          ],
        ),
        Spacer(
          flex: 2,
        ),
        Padding(
          padding: new EdgeInsets.all(32.0),
          child: new SizedBox(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: chart,
          ),
        ),
        Spacer(
          flex: 3,
        ),
      ]);
    });
  }
}

class StockPerOutlet {
  final String outlet;
  final int stockQuantity;
  final charts.Color color;

  StockPerOutlet(this.outlet, this.stockQuantity, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
