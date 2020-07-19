import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock/modules/sales/models/stock.model.dart';
import 'package:smartstock/shared/local-storage.utils.dart';

class SalesState extends BFastUIState {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
  List<dynamic> _stocks = [];
  Future loading;

  List<dynamic> get stocks {
    return this._stocks;
  }

  SalesState() {
    this.setLoadingFuture(loading: this.getStockFromRemoteAndStoreInCache());
  }

  setLoadingFuture({Future loading}) {
    this.loading = loading;
    notifyListeners();
  }

  // List<Stock> getStockFromCache(){

  // }

  Future getStockFromRemoteAndStoreInCache() async {
    await getStockFromRemote();
    // await storeStockInCache();
    // print(">>>>>>>>> Done getting data");
    notifyListeners();
  }

  Future getStockFromRemote() async {
    var shop = await _storage.getActiveShop();
    this._stocks =
        await BFast.database(shop['projectId']).collection("stocks").getAll();
//    stocks.forEach((remoteStock) {
//      Stock stock = new Stock(
//          productCategory: remoteStock["category"],
//          productName: remoteStock["product"],
//          retailPrice: remoteStock["retailPrice"].toString(),
//          wholesalePrice: remoteStock["wholesalePrice"].toString());
//      this._stocks.add(stock);
//    });
    notifyListeners();
  }

  Future storeStockInCache(List<Stock> stocks) async {
    return _storage.saveStocks(stocks);
  }

// void listenToRemoteStockUpdate(){
//   // TODO: Implement socket to listen to remote stock updates
// }
}
