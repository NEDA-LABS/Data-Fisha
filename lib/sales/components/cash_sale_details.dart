import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/cash_sale_refund.dart';
import 'package:smartstock/sales/services/sales.dart';

cashSaleDetail(context, Map sale) {
  // var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  // var title = Text(sale['product'] ?? '', style: titleStyle);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      shrinkWrap: true,
      children: [
        // ListTile(title: title, dense: true),
        _actionButtons(context, sale),
        ..._saleFields(sale)
      ],
    ),
  );
}

List _saleFields(sale) {
  return sale.keys
      .where((k) => k != 'product' && k != 'items')
      .map((e) => _listItem(e, sale))
      .toList();
}

_actionButtons(context, sale) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        outlineActionButton(
          onPressed: () => rePrintASale(sale),
          title: 'Print',
        ),
        outlineActionButton(
          onPressed: () => _showItems(sale),
          title: 'Show items',
        )
      ],
    ),
  );
}

_showItems(sale) {
  navigator().maybePop().whenComplete((){

  });
}

_prepareRefundPressed(context, sale) {
  var view = _prepareRefundView(context, sale);
  return () => navigator().maybePop().whenComplete(view);
}

_prepareRefundView(context, sale) {
  Widget builder(context) => Dialog(child: CashSaleRefundContent(sale));
  return () => showDialog(context: context, builder: builder);
}

_listItem(e, item) {
  var titleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
  var subStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  var subtitle = Text('${item[e]}', style: subStyle);
  if (e == 'sellerObject') {
    var getSeller = compose(
        [propertyOr('username', (p0) => ''), propertyOrNull('sellerObject')]);
    subtitle = Text('${getSeller(item)}', style: subStyle);
  }
  // if (e == 'items') {
  //   var items = compose([itOrEmptyArray(item),propertyOrNull('items')]) as List;
  //   var getName = compose([propertyOr('product', (p0) => ''),propertyOrNull('stock')]);
  //   subtitle = Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: items.map((e) => Text('''
  //     Name: ${getName(e)}
  //     ''', style: subStyle)).toList(),
  //   );
  // }
  return ListTile(
    title: Text('$e', style: titleStyle),
    subtitle: subtitle,
    dense: true,
  );
}
