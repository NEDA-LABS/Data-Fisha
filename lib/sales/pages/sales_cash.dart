import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/sale_cash_details.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/services/sales.dart';

class SalesCashPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const SalesCashPage({
    Key? key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key, pageName: 'SalesCashPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesCashPage> {
  bool _loading = false;
  final String _query = '';
  int size = 20;
  List _sales = [];

  _onItemPressed(item) {
    showDialogOrModalSheet(
        CashSaleDetail(sale: item, pageContext: context), context);
  }

  _itemsSize(c) {
    var getItems = compose([
      (x) => x.fold(
            0,
            (a, element) => doubleOrZero(a) + doubleOrZero(element['quantity']),
          ),
      itOrEmptyArray,
      propertyOrNull('items')
    ]);
    return getItems(c);
  }

  _getTimer(c) {
    var getTimer = propertyOr('timer', (p0) => '');
    var date = DateTime.tryParse(getTimer(c)) ?? DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(date);
  }

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Cash sales",
      showBack: true,
      backLink: '/sales/',
      showSearch: false,
      onBack: widget.onBackPage,
      context: context,
    );
  }

  _contextSales(context) {
    return [
      ContextMenu(
        name: 'Add Retail',
        pressed: () =>
            widget.onChangePage(SalesCashRetail(onBackPage: widget.onBackPage)),
      ),
      ContextMenu(
        name: 'Add Wholesale',
        pressed: () =>
            widget.onChangePage(SalesCashWhole(onBackPage: widget.onBackPage)),
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    return const SizedBox(
      height: 38,
      child: TableLikeListRow([
        TableLikeListTextHeaderCell('Customer'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Items'),
        TableLikeListTextHeaderCell('Date'),
      ]),
    );
  }

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/sales/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          _loadingView(_loading),
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextSales(context)),
          getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        loading: _loading,
        onLoadMore: () async => _loadMore(),
        // fab: FloatingActionButton(
        //   onPressed: () => _showMobileContextMenu(context),
        //   child: const Icon(Icons.unfold_more_outlined),
        // ),
        totalDynamicChildren: _sales.length,
        dynamicChildBuilder: getIsSmallScreen(context)
            ? _smallScreenChildBuilder
            : _largerScreenChildBuilder,
      );

  _loadMore() {
    setState(() {
      _loading = true;
    });
    var getSales = _prepareGetSales(_query, size, true);
    getSales(_sales).then((value) {
      if (value is List) {
        _sales.addAll(value);
        _sales = _sales.toSet().toList();
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _refresh() {
    setState(() {
      _loading = true;
    });
    var getSales = _prepareGetSales(_query, size, false);
    getSales(_sales).then((value) {
      if (value is List) {
        _sales = value;
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _defaultLast() {
    var dF = DateFormat('yyyy-MM-ddTHH:mm');
    var date = DateTime.now().add(const Duration(days: 1));
    return dF.format(date);
  }

  _prepareGetSales(String product, size, bool more) {
    return ifDoElse(
      (sales) => sales is List && sales.isNotEmpty,
      (sales) {
        var last = more ? sales.last['timer'] : _defaultLast();
        return getCashSalesFromCacheOrRemote(last, size, product);
      },
      (sales) => getCashSalesFromCacheOrRemote(_defaultLast(), size, product),
    );
  }

  Widget _customerView(c) {
    var textStyle = const TextStyle(
        fontWeight: FontWeight.w300,
        color: Color(0xffababab),
        height: 2.0,
        fontSize: 12,
        overflow: TextOverflow.ellipsis);
    var mainTextStyle = const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis);
    var subText = c['channel'] == 'whole' ? 'Wholesale' : 'Retail';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            '${c['customer'] ?? ''}'.isEmpty
                ? 'Walk in customer'
                : c['customer'],
            style: mainTextStyle),
        Text(subText, style: textStyle)
      ]),
    );
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => _onItemPressed(_sales[index]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _customerView(_sales[index]),
              Text('${compactNumber(_sales[index]['amount'])}')
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getTimer(_sales[index])}',
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis, fontSize: 14),
              ),
              Text(
                'Items ${doubleOrZero(_itemsSize(_sales[index]))}',
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const HorizontalLine(),
      ],
    );
  }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _onItemPressed(_sales[index]),
          child: TableLikeListRow([
            _customerView(_sales[index]),
            TableLikeListTextDataCell(
                '${formatNumber(_sales[index]['amount'])}'),
            TableLikeListTextDataCell(
                '${doubleOrZero(_itemsSize(_sales[index]))}'),
            TableLikeListTextDataCell('${_getTimer(_sales[index])}'),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

// void _showMobileContextMenu(context) {
//   showDialogOrModalSheet(
//       Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.add),
//               title: const Text('Add retail'),
//               onTap: () => navigateTo('/sales/cash/retail'),
//             ),
//             HorizontalLine(),
//             ListTile(
//               leading: const Icon(Icons.business),
//               title: const Text('Add wholesale'),
//               onTap: () => navigateTo('/sales/cash/whole'),
//             ),
//             HorizontalLine(),
//             ListTile(
//               leading: const Icon(Icons.refresh),
//               title: const Text('Reload sales'),
//               onTap: () {
//                 Navigator.of(context).maybePop();
//                 _refresh();
//               },
//             ),
//           ],
//         ),
//       ),
//       context);
// }
}
