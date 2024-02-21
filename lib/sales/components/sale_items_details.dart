import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';

class SaleItemsDetails extends StatefulWidget {
  final dynamic sale;
  final void Function(dynamic item) onRefund;

  const SaleItemsDetails({
    required this.sale,
    required this.onRefund,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleItemsDetails> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _header(context, widget.sale),
        _tableHeader(),
        ..._itemsList(),
      ],
    );
  }

  _tableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
      child: SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListHeaderCell('Product'),
          TableLikeListHeaderCell('Quantity'),
          TableLikeListHeaderCell('Amount ( TZS )')
        ]),
      ),
    );
  }

  _header(context, item) {
    return Container(
      height: 50,
      color: Theme.of(context).primaryColorDark,
      padding: const EdgeInsets.all(16),
      child: const BodyLarge(text: 'Items', overflow: TextOverflow.ellipsis),
    );
  }

  List<Widget> _itemsList() {
    var getName = compose([propertyOrNull('product'), propertyOrNull('stock')]);
    var getQuantity = propertyOrNull('quantity');
    var getQuantityRefund = propertyOrNull('quantity_refund');
    var getAmount = propertyOrNull('amount');
    var getAmountRefund = propertyOrNull('amount_refund');
    var nameMargin = const EdgeInsets.symmetric(vertical: 10, horizontal: 16);
    var refundTextStyle = const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 14,
    );
    var getSaleId = propertyOr('id', (_) => '');
    map2Widget(item) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableLikeListRow(
            [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: nameMargin,
                      child: BodyLarge(text: '${getName(item)}')),
                  Container(
                    margin: nameMargin,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).maybePop().whenComplete(() {
                          widget.onRefund(item);
                        });
                      },
                      child: BodyMedium(
                        text: 'Refund'
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: nameMargin, child: BodyLarge(text: '${getQuantity(item)}')),
                  Container(
                      margin: nameMargin,
                      child: BodyMedium(text: '${getQuantityRefund(item)}'))
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: nameMargin, child: BodyLarge(text: '${getAmount(item)}')),
                  Container(
                    margin: nameMargin,
                    child: BodyMedium(
                      text: '${getAmountRefund(item)}'
                    ),
                  )
                ],
              ),
            ],
          ),
          HorizontalLine()
        ],
      );
    }

    return widget.sale['items'].map<Widget>(map2Widget).toList();
  }
}
