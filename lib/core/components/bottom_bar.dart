import 'package:flutter/material.dart';
import 'package:smartstock/core/components/drawer.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

Widget bottomBar(
  int selected,
  List<MenuModel> menus,
  BuildContext context,
) =>
    isSmallScreen(context)
        ? BottomNavigationBar(
            currentIndex: selected,
            selectedItemColor: Theme.of(context).primaryColorDark,
            unselectedItemColor: Colors.grey,
            onTap: (index) => _handleClick(index, context, menus),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.point_of_sale),
                label: 'Sales',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Stocks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dehaze),
                label: 'Menu',
              ),
            ],
          )
        : null;

_handleClick(int index, BuildContext context, List<MenuModel> menus) {
  switch (index) {
    case 1:
      navigateTo('/sales');
      break;
    case 2:
      navigateTo('/stock');
      break;
    case 3:
      showModalBottomSheet(
        context: context,
        builder: (_) => modulesMenuContent('Menu', menus, ''),
      );
  }
}
