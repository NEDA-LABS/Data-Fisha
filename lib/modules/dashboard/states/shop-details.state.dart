import 'package:bfastui/adapters/state.dart';
import 'package:smartstock/modules/dashboard/models/shop.dart';

class ShopDetailsState extends BFastUIState {
  Shop _shop;

  ShopDetailsState() {
    addShop(newShop: Shop(name: "Fish Genge"));
  }

  Shop get shop => _shop;

  void addShop({Shop newShop}) {
    if (newShop != null) {
      this._shop = newShop;
      notifyListeners();
    }
  }
}
