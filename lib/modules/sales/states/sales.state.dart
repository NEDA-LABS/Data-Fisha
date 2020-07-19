import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock/shared/local-storage.utils.dart';

class SalesState extends BFastUIState {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
  List<dynamic> _stocks = [];

//  Future loading;
  bool loadProductsProgress = false;

  List<dynamic> get stocks {
    return this._stocks;
  }

//  SalesState() {
//    getStockFromCache();
//  }

  Future getStockFromCache() async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var stocks = await _storage.getStocks();
      if (stocks == null) {
        await getStockFromRemote();
      } else if (stocks != null && stocks.length == 0) {
        await getStockFromRemote();
      }
      this._stocks = stocks;
    } catch (e) {
      throw e;
    } finally {
      loadProductsProgress = false;
      notifyListeners();
    }
  }

  Future getStockFromRemote() async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var shop = await _storage.getActiveShop();
      var stocks =
          await BFast.database(shop['projectId']).collection("stocks").getAll();
      if (stocks != null) {
        this._stocks = stocks;
      } else {
        this._stocks = [];
      }
      await _storage.saveStocks(this._stocks);
    } catch (e) {
      throw e;
    } finally {
      loadProductsProgress = false;
      notifyListeners();
    }
  }

// void listenToRemoteStockUpdate(){
//   // TODO: Implement socket to listen to remote stock updates
// }
}
