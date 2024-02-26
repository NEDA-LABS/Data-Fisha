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
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/SearchFilter.dart';
import 'package:smartstock/core/models/date_range_name.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/report/components/export_options.dart';
import 'package:smartstock/report/services/export.dart';
import 'package:smartstock/sales/services/report.dart';

class SoldItemsPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const SoldItemsPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'SoldItemsPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SoldItemsPage> {
  bool _loading = false;
  TextEditingController _searchInputController = TextEditingController();

  // int size = 20;
  List _filteredSoldItems = [];
  List _soldItems = [];
  DateRangeName _rangeName = DateRangeName.today;
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  _onItemPressed(item) {}

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
              _rangeName = DateRangeName.today;
              _dateTimeRange =
                  DateTimeRange(start: DateTime.now(), end: DateTime.now());
              _refresh();
            },
            selected: _rangeName == DateRangeName.today),
        SearchFilter(
            name: "Yesterday",
            onClick: () {
              _rangeName = DateRangeName.yesterday;
              _dateTimeRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 1)),
                  end: DateTime.now().subtract(const Duration(days: 1)));
              _refresh();
            },
            selected: _rangeName == DateRangeName.yesterday),
        SearchFilter(
            name: "Last Week",
            onClick: () {
              _rangeName = DateRangeName.week;
              _dateTimeRange = DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 7)),
                  end: DateTime.now());
              _refresh();
            },
            selected: _rangeName == DateRangeName.week),
        SearchFilter(
            name: "Custom Dates",
            onClick: _onCustomDatesClicked,
            selected: _rangeName == DateRangeName.custom),
      ],
      searchTextController: _searchInputController,
      onSearch: (p0) {
        _updateState(() {
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
      ContextMenu(name: 'Export', pressed: _handleOnExport),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    return const SizedBox(
      height: 38,
      child: TableLikeListRow([
        TableLikeListHeaderCell('Product'),
        TableLikeListHeaderCell('Amount ( TZS )'),
        TableLikeListHeaderCell('Quantity'),
        TableLikeListHeaderCell('Purchase ( TZS )'),
        TableLikeListHeaderCell('Refund ( TZS )'),
        TableLikeListHeaderCell('Refund Quantity'),
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
  Widget build(context) {
    var isSmallScreen = getIsSmallScreen(context);
    var tableContext = isSmallScreen
        ? Container()
        : getTableContextMenu(_contextSales(context));
    var tableHeader = isSmallScreen ? Container() : _tableHeader();
    var fab = FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined));
    var dynamicBuilder =
        isSmallScreen ? _smallScreenChildBuilder : _largerScreenChildBuilder;

    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      current: '/sales/',
      sliverAppBar: _appBar(context),
      staticChildren: _loading
          ? [_getLoaderSpinner()]
          : [_getFromToTextIndicator(), tableContext, tableHeader],
      loading: _loading,
      // onLoadMore: () async => _loadMore(),
      fab: fab,
      totalDynamicChildren: _filteredSoldItems.length,
      dynamicChildBuilder: dynamicBuilder,
    );
  }

  _updateState(VoidCallback fn) {
    setState(fn);
  }

  _refresh() {
    _updateState(() {
      _loading = true;
    });
    getSoldItems(_dateTimeRange).then((value) {
      if (value is List) {
        _soldItems = [...value ?? []];
        _filteredSoldItems = [...value ?? []];
        _searchInputController = TextEditingController();
      }
    }).catchError((error) {
      showTransactionCompleteDialog(context, error, title: "Error",onClose: (){

      });
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  Widget _productNameView(c) {
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _productNameView(_filteredSoldItems[index]),
              ),
              const WhiteSpacer(width: 16),
              BodyLarge(
                  text: '${formatNumber(_filteredSoldItems[index]['amount'])}')
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

  void _showMobileContextMenu(context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                leading: const Icon(Icons.download_rounded),
                title: const BodyLarge(text: 'Export'),
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    _handleOnExport();
                  });
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _refresh();
                },
              ),
            ],
          ),
        ),
        context);
  }

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
        firstDate: startDate!,
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
      _rangeName = DateRangeName.custom;
      _refresh();
    }).catchError((error) {
      showTransactionCompleteDialog(context, error,onClose: (){

      });
    });
  }

  Widget _datePickerBuilder(BuildContext context, Widget? child, String title) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
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
      ),
    );
  }

  void _handleOnExport() {
    showDialogOrModalSheet(
      dataExportOptions(onPdf: () {
        exportPDF(
            "Sold items ${toSqlDate(_dateTimeRange.start)} -> ${toSqlDate(_dateTimeRange.end)}",
            _soldItems);
        Navigator.maybePop(context);
      }, onCsv: () {
        exportToCsv(
            "Sold items ${toSqlDate(_dateTimeRange.start)} -> ${toSqlDate(_dateTimeRange.end)}",
            _soldItems);
        Navigator.maybePop(context);
      }, onExcel: () {
        exportToExcel(
            "Sold items ${toSqlDate(_dateTimeRange.start)} -> ${toSqlDate(_dateTimeRange.end)}",
            _soldItems);
        Navigator.maybePop(context);
      }),
      context,
    );
  }

  _getFromToTextIndicator() {
    return Row(
      children: [
        _rangeName == DateRangeName.custom
            ? LabelLarge(text: "From: ${toSqlDate(_dateTimeRange.start)}")
            : Container(),
        const WhiteSpacer(width: 8),
        _rangeName == DateRangeName.custom
            ? LabelLarge(text: "To: ${toSqlDate(_dateTimeRange.end)}")
            : Container(),
      ],
    );
  }

  _getLoaderSpinner() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(24),
          child: const CircularProgressIndicator()),
    );
  }
}
