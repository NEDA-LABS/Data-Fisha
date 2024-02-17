import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/debounce.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/search_by_container.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/sales/components/invoice_details.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/services/invoice.dart';

class InvoicesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const InvoicesPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'InvoicesPage');

  @override
  State<StatefulWidget> createState() => _InvoicesPage();
}

class _InvoicesPage extends State<InvoicesPage> {
  final _debounce = Debounce(milliseconds: 500);
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _invoices = [];
  Map<String, String> _searchByMap = {'name': "Customer", 'value': 'customer'};

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Invoices",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onBack: widget.onBackPage,
      searchByView: SearchByContainer(
        filters: [
          SearchByFilter(
              child: const BodyLarge(text: "Customer name"),
              value: {'name': "Customer", 'value': 'customer'}),
          SearchByFilter(
              child: const BodyLarge(text: "Invoice date"),
              value: {'name': "Invoice date", 'value': 'date'}),
        ],
        currentValue: _searchByMap['name'] ?? '',
        onUpdate: (searchMap) {
          _updateState(() {
            _searchByMap = searchMap;
          });
          _refresh();
        },
      ),
      onSearch: (d) {
        _debounce.run(() {
          if (kDebugMode) {
            print(d);
          }
          _query = d;
          _refresh();
        });
      },
      context: context,
    );
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _contextInvoices(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () =>
            widget.onChangePage(InvoiceSalePage(onBackPage: widget.onBackPage)),
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    return SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListHeaderCell('Customer'),
        TableLikeListHeaderCell('Date'),
        TableLikeListHeaderCell('Amount ( TZS )'),
        TableLikeListHeaderCell('Paid ( TZS )'),
        TableLikeListHeaderCell('Status'),
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
    var tableHeader = isSmallScreen ? Container() : _tableHeader();
    var menuContext = isSmallScreen
        ? Container()
        : getTableContextMenu(_contextInvoices(context));
    var fab = FloatingActionButton(
      onPressed: () => _showMobileContextMenu(context),
      child: const Icon(Icons.unfold_more_outlined),
    );
    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      current: '/sales/',
      sliverAppBar: _appBar(context),
      staticChildren: [menuContext, _loadingView(_loading), tableHeader],
      fab: fab,
      totalDynamicChildren: _invoices.length,
      dynamicChildBuilder:
          isSmallScreen ? _smallScreenChildBuilder : _largerScreenChildBuilder,
      loading: _loading,
      onLoadMore: () async => _loadMore(),
    );
  }

  _loadMore() {
    _updateState(() {
      _loading = true;
    });
    var getInvoices = _prepareGetInvoices(
        size: size,
        more: true,
        filterBy: _searchByMap['value'] ?? 'customer',
        filterValue: _query);
    getInvoices(_invoices).then((value) {
      if (value is List) {
        _invoices.addAll(value);
        _invoices = _invoices.toSet().toList();
      }
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  _prepareGetInvoices(
      {required String filterBy,
      required String filterValue,
      required int size,
      required bool more}) {
    return ifDoElse(
      (sales) => sales is List && sales.isNotEmpty,
      (sales) {
        var last = more ? sales.last['timer'] : _defaultLast();
        return getInvoiceSalesFromCacheOrRemote(
            last, size, filterBy, filterValue);
      },
      (sales) => getInvoiceSalesFromCacheOrRemote(
          _defaultLast(), size, filterBy, filterValue),
    );
  }

  _refresh() {
    _updateState(() {
      _loading = true;
    });
    var getInvoices = _prepareGetInvoices(
        size: size,
        more: false,
        filterBy: _searchByMap['value'] ?? 'customer',
        filterValue: _query);
    getInvoices(_invoices).then((value) {
      if (value is List) {
        _invoices = value;
      }
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  _defaultLast() {
    var dF = DateFormat('yyyy-MM-ddTHH:mm');
    var date = DateTime.now().add(const Duration(days: 1));
    return dF.format(date);
  }

  final _getCustomer = compose([
    propertyOr('displayName', (p0) => 'Walk in customer'),
    propertyOrNull('customer')
  ]);

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => showDialogOrModalSheet(
              invoiceDetails(context, _invoices[index]), context),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableLikeListTextDataCell('${_getCustomer(_invoices[index])}'),
              _getStatusView(_invoices[index])
            ],
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_invoices[index]['date']}'),
                  Text(
                      'total ${compactNumber('${_invoices[index]['amount']}')}'),
                ],
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
          onTap: () => showDialogOrModalSheet(
              invoiceDetails(context, _invoices[index]), context),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${_getCustomer(_invoices[index])}'),
            TableLikeListTextDataCell(
                '${toSqlDate(DateTime.tryParse(_invoices[index]['date']) ?? DateTime.now())}'),
            TableLikeListTextDataCell(
                '${formatNumber(_invoices[index]['amount'])}'),
            TableLikeListTextDataCell('${_getInvPayment(_invoices[index])}'),
            Center(child: _getStatusView(_invoices[index]))
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  _getInvPayment(invoice) {
    if (invoice is Map) {
      var payments = invoice['payments'];
      if (payments is List) {
        var a = payments.fold(0,
            (dynamic a, element) => a + doubleOrZero('${element['amount']}'));
        return formatNumber(a);
      }
    }
    return 0;
  }

  _getStatusView(invoice) {
    var tStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C));
    var amount = doubleOrZero(invoice['amount']);
    var paidView = Container(
      height: 24,
      width: 76,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text("Paid", style: tStyle),
    );
    getPayment() {
      var payments = invoice['payments'];
      if (payments is List) {
        return payments.fold(0,
            (dynamic a, element) => a + doubleOrZero('${element['amount']}'));
      }
      return 0;
    }

    var paid = getPayment();
    if (paid >= amount) {
      return paidView;
    } else {
      return Container(
        height: 24,
        width: 76,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text("${formatNumber((paid * 100) / amount, decimals: 0)}%",
            style: tStyle),
      );
    }
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
                leading: const Icon(Icons.add),
                title: const Text('Add invoice'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  widget.onChangePage(
                    InvoiceSalePage(
                      onBackPage: widget.onBackPage,
                    ),
                  );
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload invoices'),
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
}
