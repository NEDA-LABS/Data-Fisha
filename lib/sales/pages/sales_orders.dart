import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyMedium.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/debounce.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/search_by_container.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/sales/components/invoice_details.dart';
import 'package:smartstock/sales/components/order_details.dart';
import 'package:smartstock/sales/services/orders_api.dart';

import '../../core/components/BodyLarge.dart';

class OrdersPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const OrdersPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'OrdersPage');

  @override
  State<StatefulWidget> createState() => _OrdersPage();
}

class _OrdersPage extends State<OrdersPage> {
  Map _shop = {};
  final _debounce = Debounce(milliseconds: 500);
  bool _loading = false;
  String _query = '';
  int size = 20;
  List _orders = [];
  Map<String, String> _searchByMap = {
    'name': "Pay Reference",
    'value': 'orders.payment_reference'
  };

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Orders",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onBack: widget.onBackPage,
      searchByView: SearchByContainer(
        filters: [
          SearchByFilter(
              child: const BodyLarge(text: "Payment reference number"),
              value: {
                'name': "Reference",
                'value': 'orders.payment_reference'
              }),
          SearchByFilter(
              child: const BodyLarge(text: "Customer name"),
              value: {'name': "Customer", 'value': 'orders_shipping.fullname'}),
          SearchByFilter(
              child: const BodyLarge(text: "Product name"),
              value: {'name': "Product", 'value': 'orders_cart.product'}),
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
    return [ContextMenu(name: 'Reload', pressed: () => _refresh())];
  }

  Widget _tableHeader() {
    var height = 38.0;
    return SizedBox(
      height: height,
      child: TableLikeListRow([
        const LabelMedium(text: 'CUSTOMER'),
        const LabelMedium(text: 'DATE'),
        LabelMedium(text:
        'AMOUNT ( ${_shop['settings']?['currency'] ?? 'TZS'} )'),
        const LabelMedium(text: 'STATUS'),
        const LabelMedium(text: 'ACTION'),
      ]),
    );
  }

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    getActiveShop().then((value) {
      setState(() {
        _shop = value;
      });
    });
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    var isSmallScreen = getIsSmallScreen(context);
    var tableHeader = isSmallScreen ? Container() : _tableHeader();
    var menuContext = getTableContextMenu(_contextInvoices(context));
    var fab = FloatingActionButton(
      onPressed: () => _showMobileContextMenu(context),
      child: const Icon(Icons.unfold_more_outlined),
    );
    return ResponsivePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      current: '/sales/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        menuContext,
        _loadingView(_loading),
        tableHeader,
      ],
      fab: fab,
      totalDynamicChildren: _orders.length,
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
    var getInvoices = _prepareGetOrders(
        size: size,
        more: true,
        filterBy: _searchByMap['value'] ?? 'orders.payment_reference',
        filterValue: _query);
    getInvoices(_orders).then((value) {
      if (value is List) {
        _orders.addAll(value);
        _orders = _orders.toSet().toList();
      }
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  _prepareGetOrders({
    required String filterBy,
    required String filterValue,
    required int size,
    required bool more,
  }) {
    return ifDoElse(
      (orders) => orders is List && orders.isNotEmpty,
      (orders) {
        var last = more ? orders.last['createdAt'] : _defaultLast();
        return getOrdersAPI(last, size, filterBy, filterValue);
      },
      (orders) => getOrdersAPI(_defaultLast(), size, filterBy, filterValue),
    );
  }

  _refresh() {
    _updateState(() {
      _loading = true;
    });
    var getInvoices = _prepareGetOrders(
        size: size,
        more: false,
        filterBy: _searchByMap['value'] ?? 'orders.payment_reference',
        filterValue: _query);
    getInvoices(_orders).then((value) {
      if (value is List) {
        _orders = value;
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
    firstLetterUpperCase,
    propertyOr('fullname', (p0) => 'Online customer'),
    propertyOrNull('shipping')
  ]);

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => showDialogOrModalSheet(
              invoiceDetails(context, _orders[index]), context),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableLikeListTextDataCell('${_getCustomer(_orders[index])}'),
              _getStatusView(_orders[index])
            ],
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyLarge(text: '${_orders[index]['date']}'),
                  BodyLarge(
                      text:
                          '${_shop['settings']?['currency'] ?? 'TZS'} ${formatNumber('${_orders[index]['amount']}')}'),
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
          onTap: () => _showOrderOptions(context, _orders[index]),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${_getCustomer(_orders[index])}'),
            TableLikeListTextDataCell(
                '${toSqlDate(DateTime.tryParse(_orders[index]['date']) ?? DateTime.now())}'),
            TableLikeListTextDataCell(
                '${formatNumber(_orders[index]['amount'])}'),
            Container(
              child: _getStatusView(_orders[index]),
              alignment: AlignmentDirectional.topStart,
            ),
            Container(
              alignment: AlignmentDirectional.topStart,
              child: TextButton(
                  onPressed: () => _showOrderOptions(context, _orders[index]),
                  child: const BodyMedium(text: 'Options')),
            ),
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  _showOrderOptions(BuildContext context, order) {
    showDialogOrModalSheet(
      orderDetails(context, order),
      context,
    );
    // showDialogOrModalSheet(
    //     Container(
    //       padding: const EdgeInsets.all(24),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           Row(
    //             children: [
    //               const WhiteSpacer(width: 8),
    //               const Icon(Icons.call_to_action_outlined),
    //               const WhiteSpacer(width: 8),
    //               TitleMedium(text: "Manage order #${order?['id'] ?? ''}"),
    //             ],
    //           ),
    //           const WhiteSpacer(height: 16),
    //           // order?['completed'] == false && order?['paid'] == true
    //           //     ? ListTile(
    //           //         onTap: () {
    //           //           Navigator.of(context).maybePop().whenComplete(() {
    //           //             showInfoDialog(context, "Your about to register the order to your sales ");
    //           //           });
    //           //         },
    //           //         title: const BodyLarge(text: "Process order"),
    //           //       )
    //           //     : Container(),
    //           order?['completed'] == false
    //               ? const HorizontalLine()
    //               : Container(),
    //           ListTile(
    //             onTap: () {
    //               Navigator.of(context).maybePop().whenComplete(() {
    //                 showDialogOrModalSheet(
    //                   orderDetails(context, order),
    //                   context,
    //                 );
    //               });
    //             },
    //             title: const BodyLarge(text: "View items"),
    //           ),
    //           // const HorizontalLine(),
    //           // ListTile(
    //           //   onTap: () {
    //           //     _updateState(() {
    //           //       _searchByMap = {'name': "Invoice due date", 'value': 'due'};
    //           //     });
    //           //     Navigator.of(context).maybePop();
    //           //   },
    //           //   title: const BodyLarge(text: "Invoice due date"),
    //           // ),
    //           // const HorizontalLine()
    //         ],
    //       ),
    //     ),
    //     context);
  }

  _getStatusView(order) {
    // var tStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C));
    var paidView = Container(
      height: 24,
      width: 76,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: const BodyMedium(text: "PAID"),
    );

    if (order['paid'] == true) {
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
        child: const BodyMedium(text: "NOT PAID"),
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
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload orders'),
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
