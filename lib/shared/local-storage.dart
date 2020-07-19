import 'package:bfast/adapter/cache.dart';
import 'package:bfast/bfast.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/shop/states/shops.state.dart';

class SmartStockPosLocalStorage {
  CacheAdapter smartStockCache =
      BFast.cache(CacheOptions(database: 'smartstock', collection: 'config'));

  Future saveActiveShop(var shop) async {
    var response = await this.smartStockCache.set('activeShop', shop, 7);
    BFastUI.getState<ChooseShopState>().activeShop = shop;
    return response;
  }

  Future getCurrentProjectId() async {
    return await this.smartStockCache.get<String>('cPID');
  }

  Future saveCurrentProjectId(String projectId) async {
    return await this.smartStockCache.set<String>('cPID', projectId, 7);
  }

  Future getActiveShop() async {
    var response = await this.smartStockCache.get('activeShop');
    if (response != null) {
      return response;
    } else {
      throw {"message": 'No Active Shop'};
    }
  }
}
