import 'package:flutter/material.dart';
import 'package:smartstock/core/components/StockDrawer.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

Widget? getBottomBar(
  List<MenuModel> menus,
  BuildContext context,
) {
  var size = menus.length;
  var width = MediaQuery.of(context).size.width;
  return getIsSmallScreen(context)
      ? BottomNavigationBar(
          currentIndex: size>3?3:0,
          // backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (index) {
            if (index == 3) {
              fullScreeDialog(
                  context,
                  (p0) => Scaffold(
                      appBar: AppBar(
                        title: const TitleLarge(text: 'Navigation'),
                      ),
                      body: StockDrawer(menus, '', cWidth: width)));
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
                    (e) => BottomNavigationBarItem(icon: e.icon, label: e.name))
                .toList(),
            const BottomNavigationBarItem(
                icon: Icon(Icons.dehaze), label: 'Menu')
          ],
        )
      : null;
}
