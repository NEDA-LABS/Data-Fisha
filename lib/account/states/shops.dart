import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';

class ChooseShopState {
  Future getShops() async {
    var user = await getLocalCurrentUser();
    List shops = [];
    if (user['shops'] is List) {
      shops = user['shops'];
    }
    return shops;
  }

  Future setCurrentShop(var shop) async {
    String? projectId = shop["projectId"];
    await saveShopId(projectId);
    await saveActiveShop(shop);
    // navigateTo('/dashboard/');
  }
}
