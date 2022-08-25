import 'dart:async';

import 'package:flutter/material.dart';

class ItemsListState extends ChangeNotifier {
  Timer _debounce;
  String query = '';

  refresh() => notifyListeners();

  updateQuery(String q) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      query = q;
      refresh();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
