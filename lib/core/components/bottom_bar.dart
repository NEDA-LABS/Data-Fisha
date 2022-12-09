import 'package:flutter/material.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

Widget? bottomBar(
  int selected,
  List<MenuModel> menus,
  BuildContext context,
) =>
    isSmallScreen(context)
        ? BottomNavigationBar(
            currentIndex: selected > 2 ? 2 : selected,
            selectedItemColor: Theme.of(context).primaryColorDark,
            unselectedItemColor: Colors.grey,
            onTap: (index) => _handleClick(index, context, menus),
            items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard), label: 'Dashboard'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.point_of_sale), label: 'Sales'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Account'),
                // BottomNavigationBarItem(icon: Icon(Icons.dehaze), label: 'More')
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
      navigateTo('/account/');
      break;
    // case 3:
    // fullScreeDialog(context, (p0) => Scaffold(
    //   appBar: AppBar(title: const Text('Navigation'),),
    //   body: modulesMenuContent(menus, ''),
    // ));
    // showModalBottomSheet(
    //     context: context,
    //     builder: (_) => modulesMenuContent(menus, ''));
  }
}
