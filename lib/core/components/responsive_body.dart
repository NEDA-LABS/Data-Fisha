import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/drawer.dart';

import '../models/menu.dart';
import '../services/util.dart';

responsiveBody({
  String office = '',
  String current = '/',
  bool showLeftDrawer = true,
  Widget rightDrawer,
  @required List<MenuModel> menus,
  @required Widget Function(Drawer drawer) onBody,
}) {
  var paneOrPlaneBody = ifDoElse(
    (context) => hasEnoughWidth(context),
    (_) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showLeftDrawer
            ? drawer(office, menus, current)
            : const SizedBox(width: 0),
        Expanded(child: onBody(null)),
        rightDrawer ?? const SizedBox(width: 0)
      ],
    ),
    (_) => onBody(drawer(office, menus, current)),
  );
  return Builder(builder: (context) => paneOrPlaneBody(context));
}
