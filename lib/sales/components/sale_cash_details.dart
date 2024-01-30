import 'package:flutter/material.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/sale_cash_refund.dart';
import 'package:smartstock/sales/components/sale_items_details.dart';
import 'package:smartstock/sales/services/sales.dart';

class CashSaleDetail extends StatefulWidget {
  final Map sale;
  final BuildContext pageContext;

  const CashSaleDetail(
      {required this.sale, required this.pageContext, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CashSaleDetail> {
  @override
  Widget build(BuildContext context) {
    // var titleStyle = const TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
    // var title = Text(sale['product'] ?? '', style: titleStyle);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          // ListTile(title: title, dense: true),
          _actionButtons(context),
          ..._saleFields()
        ],
      ),
    );
  }

  List _saleFields() {
    return widget.sale.keys
        .where((k) => k != 'product' && k != 'items')
        .map((e) => _listItem(e, widget.sale))
        .toList();
  }

  _actionButtons(context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuContextAction(
            onPressed: () => rePrintASale(widget.sale),
            title: 'Print',
          ),
          MenuContextAction(
            onPressed: () => _showItems(),
            title: 'Show items',
          )
        ],
      ),
    );
  }

  _showItems() {
    Navigator.of(context).maybePop().whenComplete(() {
      showDialogOrModalSheet(
          SaleItemsDetails(
            sale: widget.sale,
            onRefund: _prepareRefundPressed,
          ),
          context);
    });
  }

  _prepareRefundPressed(item) {
    showDialog(
      context: widget.pageContext,
      builder: (context) {
        return Dialog(
          child: CashSaleRefundContent(
            propertyOrNull('id')(widget.sale),
            item,
          ),
        );
      },
    );
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
    return ListTile(
      title: Text('$e', style: titleStyle),
      subtitle: subtitle,
      dense: true,
    );
  }
}
