import 'package:bfastui/bfastui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopComponents {
  Widget get chooseShop {
    return BFastUI.component().custom(
      (context) => Container(
        color: Theme.of(context).primaryColorDark,
        child: ListView(),
      ),
    );
  }
}
