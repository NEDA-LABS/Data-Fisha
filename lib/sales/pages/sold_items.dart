import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/services/report.dart';

enum _RangeName { TODAY, YESTERDAY, WEEK, CUSTOM }

class SoldItemsPage extends StatefulWidget {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const SoldItemsPage({
    Key? key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SoldItemsPage> {
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _filteredSoldItems = [];
  List _soldItems = [];
  _RangeName _rangeName = _RangeName.TODAY;
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  _onItemPressed(item) {
    // showDialogOrModalSheet(
    //     CashSaleDetail(sale: item, pageContext: context), context);
  }

  _productQuantity(c) {
    return c['quantity'];
  }

  _getTimer(c) {
    var getTimer = propertyOr('timer', (p0) => '');
    var date = DateTime.tryParse(getTimer(c)) ?? DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return dateFormat.format(date);
  }

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Sold items",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onBack: widget.onBackPage,
      context: context,
      filters: [
        SearchFilter(
            name: "Today",
            onClick: () {
              _rangeName = _RangeName.TODAY;
              _dateTimeRange =
                  DateTimeRange(start: DateTime.now(), end: DateTime.now());
              _refresh();
            },
            selected: _rangeName == _RangeName.TODAY),
        SearchFilter(
            name: "Yesterday",
            onClick: () {
              _rangeName = _RangeName.YESTERDAY;
              _dateTimeRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 1)),
                  end: DateTime.now().subtract(const Duration(days: 1)));
              _refresh();
            },
            selected: _rangeName == _RangeName.YESTERDAY),
        SearchFilter(
            name: "Last Week",
            onClick: () {
              _rangeName = _RangeName.WEEK;
              _dateTimeRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 7)),
                  end: DateTime.now());
              _refresh();
            },
            selected: _rangeName == _RangeName.WEEK),
        SearchFilter(
            name: "Custom Dates",
            onClick: _onCustomDatesClicked,
            selected: _rangeName == _RangeName.CUSTOM),
      ],
      onSearch: (p0) {
        setState(() {
          _filteredSoldItems = _soldItems
              .where((element) => '${element['name']}'
                  .toLowerCase()
                  .contains('${p0 ?? ''}'.toLowerCase()))
              .toList();
        });
      },
    );
  }

  _contextSales(context) {
    return [
      ContextMenu(name: 'Export', pressed: () {}),
      // ContextMenu(
      //   name: 'Add Wholesale',
      //   pressed: () =>
      //       widget.onChangePage(SalesCashWhole(onBackPage: widget.onBackPage)),
      // ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    return const SizedBox(
      height: 38,
      child: TableLikeListRow([
        TableLikeListTextHeaderCell('Product'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Quantity'),
        TableLikeListTextHeaderCell('Purchase ( TZS )'),
        TableLikeListTextHeaderCell('Refund ( TZS )'),
        TableLikeListTextHeaderCell('Refund Quantity'),
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
          Row(
            children: [
              _rangeName == _RangeName.CUSTOM
                  ? LabelLarge(text: "From: ${toSqlDate(_dateTimeRange.start)}")
                  : Container(),
              const WhiteSpacer(width: 8),
              _rangeName == _RangeName.CUSTOM
                  ? LabelLarge(text: "To: ${toSqlDate(_dateTimeRange.end)}")
                  : Container(),
            ],
          ),
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextSales(context)),
          getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        loading: _loading,
        // onLoadMore: () async => _loadMore(),
        // fab: FloatingActionButton(
        //   onPressed: () => _showMobileContextMenu(context),
        //   child: const Icon(Icons.unfold_more_outlined),
        // ),
        totalDynamicChildren: _filteredSoldItems.length,
        dynamicChildBuilder: getIsSmallScreen(context)
            ? _smallScreenChildBuilder
            : _largerScreenChildBuilder,
      );

  _refresh() {
    setState(() {
      _loading = true;
    });
    getSoldItems(_dateTimeRange).then((value) {
      if (value is List) {
        _soldItems = [...value ?? []];
        _filteredSoldItems = [...value ?? []];
        _query = '';
      }
    }).catchError((error) {
      showInfoDialog(context, error, title: "Error");
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  Widget _productNameView(c) {
    if (kDebugMode) {
      print(c);
    }
    var subText = _getTimer(c);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BodyLarge(
            text: '${c['name'] ?? ''}'.isEmpty ? 'N/A' : c['name'],
            overflow: TextOverflow.ellipsis),
        const WhiteSpacer(height: 8),
        LabelMedium(text: subText, overflow: TextOverflow.ellipsis)
      ]),
    );
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => _onItemPressed(_filteredSoldItems[index]),
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _productNameView(_filteredSoldItems[index]),
              Text('${formatNumber(_filteredSoldItems[index]['amount'])}')
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LabelMedium(
                text:
                    'Purchased: ${formatNumber(_filteredSoldItems[index]['purchase_price'])}',
                overflow: TextOverflow.ellipsis,
              ),
              LabelMedium(
                text:
                    'Qty: ${doubleOrZero(_productQuantity(_filteredSoldItems[index]))}',
                overflow: TextOverflow.ellipsis,
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
          onTap: () => _onItemPressed(_filteredSoldItems[index]),
          child: TableLikeListRow([
            _productNameView(_filteredSoldItems[index]),
            TableLikeListTextDataCell(
                '${formatNumber(_filteredSoldItems[index]['amount'])}'),
            TableLikeListTextDataCell(
                '${doubleOrZero(_productQuantity(_filteredSoldItems[index]))}'),
            TableLikeListTextDataCell(
                '${formatNumber(_filteredSoldItems[index]['purchase_price'] ?? "0")}'),
            TableLikeListTextDataCell(
                '${formatNumber(_filteredSoldItems[index]['refund_amount'] ?? "0")}'),
            TableLikeListTextDataCell(
                '${formatNumber(_filteredSoldItems[index]['refund_quantity'] ?? "0")}'),
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

  _onCustomDatesClicked() {
    DateTime? startDate;
    DateTime? endDate;
    showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(2022),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      builder: (context, child) =>
          _datePickerBuilder(context, child, 'Select start date'),
    ).then((value) {
      if (value == null) {
        throw "Please select start date";
      }
      startDate = value;
      return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: startDate!.add(const Duration(days: 1)),
        lastDate: DateTime.now(),
        builder: (context, child) =>
            _datePickerBuilder(context, child, 'Select end date'),
      );
    }).then((value) {
      if (value == null) {
        throw "Please select end date";
      }
      endDate = value;
      _dateTimeRange = DateTimeRange(start: startDate!, end: endDate!);
      _rangeName = _RangeName.CUSTOM;
      _refresh();
    }).catchError((error) {
      showInfoDialog(context, error);
    });
  }

  Widget _datePickerBuilder(BuildContext context, Widget? child, String title) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(100)),
              child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: BodyLarge(text: title)),
            ),
            child ?? Container()
          ],
        ),
      ),
    );
  }
}
