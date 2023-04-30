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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _mapPagesForMobileViewNavigation(pages,isCompactView?2:4).map((e) {
        var remainder = (isCompactView?2:4) - e.length;
        var y = [];
        y.addAll(e);
        for(var i=0; i<remainder;i++){
          y.add(null);
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: y.map<Widget>((x) {
            return Expanded(
              flex: 1,
              child: x !=null
                  ? _menuToGridItem(context)(x as SubMenuModule)
                  : Container(),
            );
          }).toList(),
        );
      }).toList(),
    );
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
      int count
  ) {
    return divideList<SubMenuModule>(pages, count);
  }
}
