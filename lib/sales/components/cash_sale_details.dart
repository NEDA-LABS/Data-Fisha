import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/delete_dialog.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/cash_sale_refund.dart';
import 'package:smartstock/stocks/components/offset_quantity_content.dart';
import 'package:smartstock/stocks/components/product_movement.dart';
import 'package:smartstock/stocks/services/product.dart';

cashSaleDetail(context, Map sale) {
  var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  var title = Text(sale['product'] ?? '', style: titleStyle);
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      shrinkWrap: true,
      children: [
        ListTile(title: title, dense: true),
        _actionButtons(context, sale),
        ..._saleFields(sale)
      ],
    ),
  );
}

List _saleFields(sale) {
  return sale.keys
      .where((k) => k != 'product')
      .map((e) => _listItem(e, sale))
      .toList();
}

_actionButtons(context, sale) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: outlineActionButton(
      onPressed: _prepareRefundPressed(context, sale),
      title: 'Refund',
    ),
  );
}

_prepareRefundPressed(context, sale) {
  var view = _prepareRefundView(context, sale);
  return () => navigator().maybePop().whenComplete(view);
}

_prepareRefundView(context, sale) {
  Widget _builder(context) => Dialog(child: CashSaleRefundContent(sale));
  return () => showDialog(context: context, builder: _builder);
}

_listItem(e, item) {
  var titleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
  var subStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  return ListTile(
    title: Text('$e', style: titleStyle),
    subtitle: Text('${item[e]}', style: subStyle),
    dense: true,
  );
}
