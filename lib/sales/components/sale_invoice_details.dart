import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/add_invoice_payment.dart';
import 'package:smartstock/sales/components/sale_cash_refund.dart';
import 'package:smartstock/sales/components/sale_invoice_refund.dart';
import 'package:smartstock/sales/components/sale_items_details.dart';
import 'package:smartstock/sales/services/sales.dart';

class SaleInvoiceDetail extends StatefulWidget {
  final Map sale;
  final BuildContext pageContext;

  const SaleInvoiceDetail(
      {required this.sale, required this.pageContext, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleInvoiceDetail> {
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
          outlineActionButton(
            onPressed: () => rePrintASale(widget.sale),
            title: 'Print',
          ),
          outlineActionButton(
            onPressed: () => _showItems(),
            title: 'Show items',
          ),
          outlineActionButton(
            onPressed: () {
              Navigator.of(context).maybePop().whenComplete(() {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: AddInvoicePaymentContent(
                      propertyOrNull('id')(widget.sale),
                    ),
                  ),
                );
              });
            },
            title: 'Add payment',
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
          child: SaleInvoiceRefundContent(
            propertyOrNull('id')(widget.sale),
            item,
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getPayments(item) {
    if (item is Map) {
      return item.keys.map((e) => ({"date": e, "amount": item[e]})).toList();
    }
    return [];
  }

  _listItem(e, item) {
    var titleStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w300);
    var subStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    dynamic subtitle = Text('${item[e]}', style: subStyle);
    if (e == 'sellerObject') {
      var getSeller = compose(
          [propertyOr('username', (p0) => ''), propertyOrNull('sellerObject')]);
      subtitle = Text('${getSeller(item)}', style: subStyle);
    }
    if (e == 'customer') {
      var getSeller = compose(
          [propertyOr('displayName', (p0) => ''), propertyOrNull('customer')]);
      subtitle = Text('${getSeller(item)}', style: subStyle);
    }
    if (e == 'payment') {
      subtitle = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getPayments(item['payment']).map<Widget>((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${item['date']} --> '),
                Text('${item['amount']}'),
              ],
            );
          }).toList(),
        ),
      );
    }
    return ListTile(
      title: Text('$e', style: titleStyle),
      subtitle: subtitle,
      dense: true,
    );
  }
}
