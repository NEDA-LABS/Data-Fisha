import 'package:flutter/material.dart';
import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'package:smartstock_flutter_mobile/shared/card_view.dart';

class GrossProfitPerformance extends StatefulWidget {
  final Shop shop;
  GrossProfitPerformance({Key key, this.shop}) : super(key: key);

  @override
  _GrossProfitPerformanceState createState() =>
      _GrossProfitPerformanceState(shop: this.shop);
}

class _GrossProfitPerformanceState extends State<GrossProfitPerformance> {
  final Shop shop;

  _GrossProfitPerformanceState({this.shop});
  @override
  Widget build(BuildContext context) {
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
      Spacer(flex: 3,),
    ]);
  }
}
