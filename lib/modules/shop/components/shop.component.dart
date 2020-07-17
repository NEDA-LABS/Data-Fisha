import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/modules/shop/states/shops.state.dart';

class ShopComponents {
  Widget get chooseShop {
    return BFastUI.component().consumer<ShopState>(
      (context, state) => Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        color: Theme.of(context).primaryColorDark,
        child: Wrap(
          children: [this._shop],
        ),
      ),
    );
  }

  Widget get _shop {
    return BFastUI.component().custom((context) => Container(
//          onPressed: () {},
          child: FlatButton(
            onPressed: () {},
            child: Container(
              color: Colors.white,
              height: 150,
              width: 150,
              child: Icon(
                Icons.store,
                size: 70,
              ),
            ),
          ),
        ));
  }
}
