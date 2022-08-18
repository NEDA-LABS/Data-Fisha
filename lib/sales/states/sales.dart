import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/services/cache_shop.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/stocks_cache.dart';

import '../../core/services/api_stocks.dart';

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
      var stocks = await getStockFromCacheOrRemote();
      if (productFilter.isNotEmpty) {
        _stocks = stocks.where((element) => element['product']
                .toString()
                .toLowerCase()
                .contains(productFilter.toLowerCase()))
            .toList();
      } else {
        _stocks = stocks;
      }
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
   searchKeyword = s;
   // searchInputController.clear();
   notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _debounce = null;
    super.dispose();
  }
}
