import 'package:bfast/controller/cache.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock/modules/sales/models/stock.model.dart';
import 'package:bfast/bfast.dart';

class SalesState extends BFastUIState {
  List<Stock> _stocks;

  List<Stock> get stocks {
    this._stocks = [
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
      Stock(
          productCategory: "Mifugo/ Kilimo",
          productName: "aminogrow 100kg",
          productPrice: "TZS 12,000.00"),
    ];
    
    return this._stocks;
  }

  // List<Stock> getStockFromCache(){

  // }

  Future getStockFromRemoteAndStoreInCache() async {
    // TODO: Implement fetch of remote stock
    var cache = BFast.cache(CacheOptions(collection: "config", database: "smartstock"));
    var shop = await cache.get('activeShop');
    var stocks = await BFast.database('NBTnryqCyALq').collection("stocks").getAll();
    // BFast.cache();
    print(stocks);
    notifyListeners();
  }

  // List<Stock> getStockFromRemote(){

  // }

  void storeStockInCache(){

  }

  // void listenToRemoteStockUpdate(){
  //   // TODO: Implement socket to listen to remote stock updates
  // }
}
