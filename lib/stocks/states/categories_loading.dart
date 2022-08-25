import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/stocks/services/category.dart';
import 'package:smartstock_pos/stocks/states/categories_list.dart';

class CategoriesLoadingState extends ChangeNotifier {
  bool loading = false;

  refresh() => notifyListeners();

  update(bool value) {
    loading = value;
    refresh();
    getCategoryFromCacheOrRemote(skipLocal: true).whenComplete(() {
      loading = false;
      refresh();
      getState<CategoriesListState>().refresh();
    });
  }
}
