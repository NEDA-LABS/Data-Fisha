import 'dart:async';

import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/state.adapter.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';
import 'package:smartstock_pos/shared/local-storage.utils.dart';

class SalesState extends StateAdapter {
  SmartStockPosLocalStorage _storage = SmartStockPosLocalStorage();
  List<dynamic> _stocks = [];
  Timer _debounce;
  bool addToCartIsActive = false;

  bool loadProductsProgress = false;
  bool onSearchProgress = false;

  String searchKeyword = '';

  List<dynamic> get stocks {
    return this._stocks;
  }

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
      var filtered = stocks.where((element) =>
              element['saleable'] == null || element['saleable'] == true).toList();
      if (productFilter.isNotEmpty) {
        this._stocks = filtered.where((element) => element['product']
                .toString()
                .toLowerCase()
                .contains(productFilter.toLowerCase())).toList();
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
      updateCurrentShop(shop);
      // var urlS = BFast.getConfig(shop['projectId']).databaseURL(shop['projectId']);
      print(BFast.getConfig(shop['projectId']).credentials[shop['projectId']].databaseURL);
      // print(urlS);
      var stocks =
          await BFast.database(shop['projectId']).collection("stocks").getAll();
      // print(stocks);
      if (stocks != null) {
        stocks = stocks
            .where((element) =>
                element['saleable'] == null || element['saleable'] == true)
            .toList();
      } else {
        stocks = [];
      }
      await _storage.saveStocks(stocks);
      this._stocks = stocks;
      notifyListeners();
      return stocks;
    } catch (e) {
      throw e;
    } finally {
      loadProductsProgress = false;
      notifyListeners();
    }
  }

  void filterProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
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

@override
  void dispose() {
   _debounce?.cancel();_debounce = null;
    super.dispose();
  }
}
