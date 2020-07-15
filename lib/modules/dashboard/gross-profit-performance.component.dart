import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/shared/card_view.dart';

class GrossProfitPerformanceComponents {
  Widget get grossProfit {
    return BFastUI.component().custom((context) {
      return CardView(cardItems: <Widget>[
        Spacer(),
        Row(
          children: <Widget>[
            Spacer(),
            Text("Gross Profit"),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Requesting Gross Profit Information"),
              ));
              },
            ),
            Spacer()
          ],
        ),
        Spacer(
          flex: 2,
        ),
        Text(
          "TZS 0.00",
          textScaleFactor: 2.5,
        ),
        Spacer(
          flex: 3,
        ),
      ]);
    });
  }
}
