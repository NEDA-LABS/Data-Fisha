import 'package:bfast/bfast.dart';
import 'package:bfast/controller/cache.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock/modules/sales/models/stock.model.dart';

class SalesState extends BFastUIState {
  List<Stock> _stocks = [];
  Future loading;

  List<Stock> get stocks {
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
    await storeStockInCache();
    print(">>>>>>>>> Done getting data");
    notifyListeners();
  }

  Future getStockFromRemote() async {
    var cache =
        BFast.cache(CacheOptions(collection: "config", database: "smartstock"));
    var shop = await cache.get('activeShop');
    var stocks = await BFast.database().collection("stocks").getAll();

    stocks.forEach((remoteStock) {
      Stock stock = new Stock(
          productCategory: remoteStock["category"],
          productName: remoteStock["product"],
          retailPrice: remoteStock["retailPrice"].toString(),
          wholesalePrice: remoteStock["wholesalePrice"].toString());
      this._stocks.add(stock);
    });
    notifyListeners();
  }

  Future storeStockInCache() async {
    var cache =
        BFast.cache(CacheOptions(collection: "config", database: "smartstock"));
    // this._stocks.forEach((product) {

    // });
  }

// void listenToRemoteStockUpdate(){
//   // TODO: Implement socket to listen to remote stock updates
// }
}
