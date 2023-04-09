import 'package:flutter/material.dart';
import 'package:smartstock/core/components/StockDrawer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

Widget? bottomBar(
  int selected,
  List<MenuModel> menus,
  BuildContext context,
) =>
    getIsSmallScreen(context)
        ? BottomNavigationBar(
            currentIndex: selected > 3 ? 3 : selected,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            showUnselectedLabels: true,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            unselectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) => _handleClick(index, context, menus),
            items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale), label: 'Sales'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.store), label: 'Stocks'),
                BottomNavigationBarItem(icon: Icon(Icons.dehaze), label: 'More')
              ])
        : null;

_handleClick(dynamic index, BuildContext context, List<MenuModel> menus) {
  switch (index) {
    case 0:
      navigateTo('/dashboard/');
      break;
    case 1:
      navigateTo('/sales/');
      break;
    case 2:
      navigateTo('/stocks/');
      break;
    case 3:

  }
}
