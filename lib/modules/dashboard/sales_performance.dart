import 'package:flutter/material.dart';
import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'package:smartstock_flutter_mobile/shared/card_view.dart';

class SalesPerformance extends StatefulWidget {
  final Shop shop;
  SalesPerformance({Key key, this.shop}) : super(key: key);

  @override
  _SalesPerformanceState createState() =>
      _SalesPerformanceState(shop: this.shop);
}

class _SalesPerformanceState extends State<SalesPerformance> {
  final Shop shop;

  _SalesPerformanceState({this.shop});
  @override
  Widget build(BuildContext context) {
    return CardView(cardItems: <Widget>[
      Spacer(),
     Row(
        children: <Widget>[
          Spacer(),
          Text("Total Sales"),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Requesting total sales infom"),
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
