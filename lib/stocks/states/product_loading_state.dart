import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/stocks/states/products_list_state.dart';

class ProductLoadingState extends ChangeNotifier {
  bool loading = false;

  refresh() => notifyListeners();

  update(bool value) {
    loading = value;
    refresh();
    getStockFromCacheOrRemote(skipLocal: true).whenComplete(() {
      loading = false;
      refresh();
      getState<ProductsListState>().refresh();
    });
  }
}
