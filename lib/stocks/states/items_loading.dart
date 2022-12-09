import 'package:flutter/foundation.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/items.dart';
import 'package:smartstock/stocks/states/items_list.dart';


class ItemsLoadingState extends ChangeNotifier {
  bool loading = false;

  refresh() => notifyListeners();

  update(bool value) {
    loading = value;
    refresh();
    getItemFromCacheOrRemote(skipLocal: true).whenComplete(() {
      loading = false;
      refresh();
      getState<ItemsListState>().refresh();
    });
  }
}
