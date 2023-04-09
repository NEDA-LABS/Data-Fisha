import 'dart:core';

import 'package:flutter/material.dart';
import 'package:smartstock/core/components/SwitchToPageGrid.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';

class SwitchToPageMenu extends StatelessWidget {
  final List<SubMenuModule> pages;

  const SwitchToPageMenu({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isCompactView = getIsSmallScreen(context);
    var largeScreenView =
        Wrap(children: pages.map(_menuToGridItem(context)).toList());
    var smallScreenView = Column(
      mainAxisSize: MainAxisSize.min,
      children: _mapPagesForMobileViewNavigation(pages).map((e) {
        var y = e.length == 1 ? [...e, null] : e;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: y.map((x) {
            return Expanded(
              flex: 1,
              child: x is SubMenuModule
                  ? _menuToGridItem(context)(x)
                  : Container(),
            );
          }).toList(),
        );
      }).toList(),
    );
    return isCompactView ? smallScreenView : largeScreenView;
  }

  Widget Function(SubMenuModule) _menuToGridItem(BuildContext context) {
    return (e) {
      return SwitchToPageGrid(
        onPress: e.onClick,
        name: e.name,
        onIcon: () {
          var icon = e.icon != null
              ? Icon(
                  e.icon!,
                  color: Theme.of(context).colorScheme.secondary,
                )
              : Container();
          return icon;
        },
      );
    };
  }

  List<List<SubMenuModule>> _mapPagesForMobileViewNavigation(
    List<SubMenuModule> pages,
  ) {
    return divideList<SubMenuModule>(pages, 2);
  }
}
