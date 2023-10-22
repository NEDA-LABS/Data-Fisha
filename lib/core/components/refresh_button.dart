import 'package:flutter/material.dart';

Widget salesRefreshButton({
  bool loading = false,
  required List carts,
  required Function onPressed,
  required BuildContext context,
}) =>
    !loading ? _refreshStocks(carts, onPressed,context) : const SizedBox(width: 0, height: 0);

Widget _refreshStocks(List carts, onPressed,BuildContext context) => carts.isEmpty
    ? FloatingActionButton(
        onPressed: onPressed,
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    child: const Icon(Icons.refresh))
    : const SizedBox(height: 0, width: 0);
