import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/drawer.dart';

import '../models/menu.dart';
import '../services/util.dart';

responsiveBody({
  String office = '',
  String current = '/',
  @required List<MenuModel> menus,
  @required Widget Function(Drawer drawer) onBody,
}) {
  var paneOrPlaneBody = ifDoElse(
    (context) => hasEnoughWidth(context),
    (_) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        drawer(office, menus, current),
        Expanded(flex: 1, child: onBody(null))
      ],
    ),
    (_) => onBody(drawer(office, menus, current)),
  );
  return Builder(builder: (context) => paneOrPlaneBody(context));
}
