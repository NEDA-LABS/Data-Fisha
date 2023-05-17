import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/StockDrawer.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

Widget getBottomBar(List<MenuModel> menus, BuildContext context) {
  var size = menus.length;
  return BottomNavigationBar(
    currentIndex: size > 3 ? 3 : 0,
    // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    selectedFontSize: 10,
    unselectedFontSize: 10,
    selectedItemColor: Theme.of(context).colorScheme.primary,
    unselectedItemColor: Theme.of(context).colorScheme.primary,
    onTap: (index) {
      if (menus.length > 3 ? (index == 3) : (index == menus.length)) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: menus
                    .map((e) => ListTile(
                          title: BodyLarge(text: e.name),
                          leading: e.icon,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: e.onClick,
                        ))
                    .toList(),
              ),
            );
          },
        );
        return;
      }
      if (menus[index].onClick != null) {
        menus[index].onClick!();
      }
    },
    items: [
      ...menus
          .sublist(0, size <= 3 ? size : 3)
          .map<BottomNavigationBarItem>(
            (e) => BottomNavigationBarItem(icon: e.icon, label: e.name),
          )
          .toList(),
      const BottomNavigationBarItem(icon: Icon(Icons.dehaze), label: 'Menu')
    ],
  );
}
