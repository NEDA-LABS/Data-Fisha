import 'dart:async';
import 'package:bfast/controller/database.dart';
import 'package:bfast/options.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/sales/services/sales.dart';
import 'package:smartstock_pos/sales/services/sales_cache.dart';
import 'package:smartstock_pos/stocks/services/stocks_cache.dart';

class SalesState extends ChangeNotifier {
  List<dynamic> _stocks = [];
  Timer _debounce;
  bool addToCartIsActive = false;

  bool loadProductsProgress = false;
  bool onSearchProgress = false;

  String searchKeyword = '';

  List<dynamic> get stocks {
    return _stocks;
  }

  Future<List<dynamic>> getStockFromCache({String productFilter}) async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var stocks = await getLocalStocks();
      stocks ??= await getStockFromRemote();
      if (stocks != null && stocks.length == 0) {
        stocks = await getStockFromRemote();
      }
      if (productFilter.isNotEmpty) {
        // stocks = _stocks.where((element) => element['product']);
        _stocks = stocks.where((element) => element['product']
                .toString()
                .toLowerCase()
                .contains(productFilter.toLowerCase()))
            .toList();
      }
      // else {
      //   _stocks = filtered;
      // }
      return _stocks;
    } catch (e) {
      rethrow;
    } finally {
      loadProductsProgress = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getStockFromRemote() async {
    try {
      loadProductsProgress = true;
      notifyListeners();
      var shop = await getActiveShop();
      _stocks = await getAllRemoteStocks(shop);
      await saveLocalStocks(_stocks);
      return _stocks;
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
    _debounce?.cancel();
    _debounce = null;
    super.dispose();
  }
}
