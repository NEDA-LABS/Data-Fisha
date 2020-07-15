import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/shared/card_view.dart';
import 'package:smartstock/modules/dashboard/states/shop-details.state.dart';

import '../../../configurations.dart';

class DashboardShopComponents {
  Widget get currentShop {
    return BFastUI.component().consumer<ShopDetailsState>((_, shopDetail) {
      return CardView(cardItems: <Widget>[
        Spacer(),
        Icon(
          Icons.shopping_cart,
          color: Config.primaryColor,
          size: 100,
        ),
        Text(
          shopDetail.shop.name,
          textScaleFactor: 2.5,
        ),
        Spacer(
          flex: 1,
        ),
        Text("Pick a date range"),
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () {
            showDatePicker(
                context: _,
                firstDate: DateTime(DateTime.now().year - 30),
                initialDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 30));
          },
        ),
        Spacer(),
      ]);
    });
  }
}
