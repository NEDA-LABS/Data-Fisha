import 'dart:async';
import 'dart:convert';

import 'package:bfast/bfast.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/shared/local-storage.utils.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';
import 'package:smartstock_pos/util.dart';

class SalesState extends ChangeNotifier {
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
      if (stocks == null) return stocks = await getStockFromRemote();
      if (stocks != null && stocks.length == 0) {
        stocks = await getStockFromRemote();
      }
      if (productFilter.isNotEmpty) {
        this._stocks = stocks.where((element) => element['product']
                .toString()
                .toLowerCase()
                .contains(productFilter.toLowerCase()))
            .toList();
      } else {
        this._stocks = stocks;
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
      // print(BFast.getConfig(shop['projectId'])
      //     .credentials[shop['projectId']]
      //     .functionsURL);
      // print(urlS);
      String stockString = await BFast.functions(shop['projectId']).request('/stock/products').post();
      List stocks = jsonDecode(stockString) as List;
      if (stocks != null && stocks is List) {
        stocks = stocks.map((stock) {
          stock['quantity'] = getStockQuantity(stock: stock);
          return stock;
        }).toList();
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
    _debounce?.cancel();
    _debounce = null;
    super.dispose();
  }
}
