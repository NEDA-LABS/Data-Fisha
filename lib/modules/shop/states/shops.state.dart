import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';

class ShopState extends BFastUIState {
  List shops = [];

  Future getShops() async {
    try {
      var user = await BFast.auth().currentUser();
      this.shops = [];
      user['shops'].forEach((element) {
        this.shops.add(element);
      });
      this.shops.add({
        "businessName": user.businessName,
        "projectId": user.projectId,
        "applicationId": user.applicationId,
        "projectUrlId": user.projectUrlId,
        "settings": user.settings,
        "street": user.street,
        "country": user.country,
        "region": user.region
      });
      notifyListeners();
      return this.shops;
    } catch (e) {
      throw e;
    }
  }
}
