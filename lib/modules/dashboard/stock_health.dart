import 'package:flutter/material.dart';
import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'package:smartstock_flutter_mobile/shared/card_view.dart';
import 'package:charts_flutter/flutter.dart';

class StockHealth extends StatefulWidget {
  final Shop shop;
  StockHealth({Key key, this.shop}) : super(key: key);

  @override
  _StockHealthState createState() => _StockHealthState(shop: this.shop);
}

class _StockHealthState extends State<StockHealth> {
  final Shop shop;

  _StockHealthState({this.shop});
  @override
  Widget build(BuildContext context) {
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
      Text(
        "TZS 0.00",
        textScaleFactor: 2.5,
      ),
      Spacer(
        flex: 3,
      ),
    ]);
  }
}
