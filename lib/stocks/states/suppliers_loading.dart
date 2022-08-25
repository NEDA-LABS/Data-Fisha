import 'package:flutter/foundation.dart';
import 'package:smartstock_pos/core/services/util.dart';
import 'package:smartstock_pos/stocks/services/category.dart';
import 'package:smartstock_pos/stocks/services/supplier.dart';

import 'suppliers_list.dart';

class SuppliersLoadingState extends ChangeNotifier {
  bool loading = false;

  refresh() => notifyListeners();

  update(bool value) {
    loading = value;
    refresh();
    getSupplierFromCacheOrRemote(skipLocal: true).whenComplete(() {
      loading = false;
      refresh();
      getState<SuppliersListState>().refresh();
    });
  }
}
