import 'package:flutter/material.dart';
import '../../configurations.dart';
import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'package:smartstock_flutter_mobile/shared/card_view.dart';


class CurrentShop extends StatefulWidget {
  final Shop shop;
  CurrentShop({Key key, this.shop}) : super(key: key);

  @override
  _CurrentShopState createState() => _CurrentShopState(shop: this.shop);
}

class _CurrentShopState extends State<CurrentShop> {
  final Shop shop;

  _CurrentShopState({this.shop});
  @override
  Widget build(BuildContext context) {
    return CardView(
      cardItems: <Widget>[
       Spacer(),
        Icon(
             Icons.shopping_cart,
                          color: Config.primaryColor,
                          size: 100,
                        ),
                        Text(
                          shop.name,
                          textScaleFactor: 2.5,
                        ),
                        Spacer(flex: 1,),
                        Text("Pick a date range"),
                        IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 30),
                                initialDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 30));
                          },
                        ),
                        Spacer(),
    ]);
  }
  }