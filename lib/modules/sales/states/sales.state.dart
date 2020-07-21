import 'dart:async';

import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class SalesState extends BFastUIState {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
  List<dynamic> _stocks = [];
  Timer _debounce;
  bool addToCartIsActive = false;

  bool loadProductsProgress = false;
  bool onSearchProgress = false;

  String searchKeyword = '';

  // TextEditingController searchInputController = TextEditingController(text: '');

  List<dynamic> get stocks {
    return this._stocks;
  }

//  SalesState() {
//    getStockFromCache();
//  }

  Future<List<dynamic>> getStockFromCache({String productFilter}) async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var stocks = await _storage.getStocks();
      if (stocks == null) {
        stocks = await getStockFromRemote();
      }
      if (stocks != null && stocks.length == 0) {
        stocks = await getStockFromRemote();
      }
      var filtered = stocks
          ?.where((element) =>
              element['saleable'] == null || element['saleable'] == true)
          ?.toList();
      if (productFilter != null && productFilter.isNotEmpty) {
        this._stocks = filtered
            ?.where((element) => element['product']
                .toString()
                .toLowerCase()
                .contains(productFilter.toLowerCase()))
            ?.toList();
      } else {
        this._stocks = filtered;
      }
      return this._stocks;
    } catch (e) {
      throw e;
    } finally {
      loadProductsProgress = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getStockFromRemote() async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var shop = await _storage.getActiveShop();
      var stocks =
          await BFast.database(shop['projectId']).collection("stocks").getAll();
      if (stocks != null) {
        stocks
            .where((element) =>
                element['saleable'] == null || element['saleable'] == true)
            .toList();
      } else {
        stocks = [];
      }
      return await _storage.saveStocks(stocks);
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

  void filterProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (onSearchProgress != true && searchKeyword != query) {
//        print(query);
        searchKeyword = query;
        onSearchProgress = true;
        notifyListeners();
        getStockFromCache(productFilter: query)
            .catchError((_) {})
            .whenComplete(() {
          onSearchProgress = false;
          notifyListeners();
        });
      }
    });
  }

  void resetSearchKeyword(String s) {
//    this.searchKeyword = s;
//    // searchInputController.clear();
//    notifyListeners();
  }

//  void setIsAddToCartActiveFalse() {
//    addToCartIsActive = false;
//    notifyListeners();
//  }

//  void setIsAddToCartActiveTrue() {
//    addToCartIsActive = true;
//    notifyListeners();
//  }
}
