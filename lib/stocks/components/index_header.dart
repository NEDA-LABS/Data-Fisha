import 'package:flutter/widgets.dart';
import 'package:smartstock_pos/core/components/switch_to_item.dart';
import 'package:smartstock_pos/stocks/services/navigation.dart';

_title() => const Padding(
    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
    child: Text("Switch to",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)));

_links() => Wrap(children: switchToItems(stocksMenu().pages));

stocksHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_title(), _links()]);
