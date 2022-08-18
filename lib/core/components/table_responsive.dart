import 'package:bfast/util.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock_pos/core/components/table_desktop.dart';
import 'package:smartstock_pos/core/components/table_mobile.dart';
import 'package:smartstock_pos/core/services/util.dart';

responsiveTable() {
  var getTable = ifDoElse(
    (x) => isSmallScreen(x),
    (x) => mobileTable(),
    (x) => desktopTable(),
  );
  return Builder(builder: (c)=>getTable(c));
}
