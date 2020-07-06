import 'package:smartstock_flutter_mobile/models/shop.dart';
import 'package:flutter/foundation.dart';

class ShopDetailsChangeNotifier extends ChangeNotifier{
  Shop _shop;

  ShopDetailsChangeNotifier();

  Shop get shop => _shop;

  void addShop({Shop newShop}){
    if(newShop != null){
      this._shop = newShop;
      notifyListeners();
    }
  }

}