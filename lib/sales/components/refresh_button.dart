import 'package:flutter/material.dart';

import '../../core/services/util.dart';
import '../models/cart.model.dart';
import '../states/cart.dart';
import '../states/sales.dart';

Widget salesRefreshButton({
  bool loading = false,
  @required List carts,
  @required Function onPressed,
}) =>
    !loading ? _refreshStocks(carts, onPressed) : const SizedBox(width: 0, height: 0);

Widget _refreshStocks(List carts, onPressed) => carts.isEmpty
    ? FloatingActionButton(
        onPressed: onPressed, child: const Icon(Icons.refresh))
    : const SizedBox(height: 0, width: 0);
