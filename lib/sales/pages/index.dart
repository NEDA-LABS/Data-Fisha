import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/api_shop.dart';
import 'package:smartstock/core/services/location.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/number_card.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/pages/sold_items.dart';
import 'package:smartstock/sales/services/index.dart';

import 'customers.dart';

class SalesPage extends PageBase {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const SalesPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key, pageName: 'SalesPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SalesPage> {
  bool loading = false;
  DateTime date = DateTime.now();
  var data = {};
  StreamSubscription<Position>? _locationSubscriptionStream;

  @override
  void initState() {
    _fetchSummary();
    _listeningForLocation();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/sales/',
      staticChildren: [
        // loading ? const LinearProgressIndicator() : Container(),
        // const SwitchToTitle(),
        const WhiteSpacer(height: 24),
        SwitchToPageMenu(pages: _pagesMenu(context)),
        const WhiteSpacer(height: 16),
        // const TitleMedium(text: 'Summary'),
        // const WhiteSpacer(height: 8),
        loading
            ? const Center(child: CircularProgressIndicator())
            : _getTotalSalesView(context),
      ],
      sliverAppBar: SliverSmartStockAppBar(
          title: "Sales", showBack: false, context: context),
    );
  }

  void _fetchSummary() {
    setState(() {
      loading = true;
    });
    getSalesReport(date).then((value) {
      // setState(() {
      data = value;
      // });
    }).catchError((onError) {
      // setState(() {
      //   error = '$onError';
      // });
      if (kDebugMode) {
        print(onError);
      }
    }).whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  // _getIt(String p, data) => data is Map ? data[p] : null;

  _getTotalSalesView(BuildContext context) {
    var getView = ifDoElse(
      (context) => getIsSmallScreen(context),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getRevenueCards(),
          _getSoldItemsTable(true),
          _getReceiptsTable(true),
          _getInvoicesTable(true),
        ],
      ),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _getSoldItemsTable(false),
              ),
              Expanded(
                flex: 2,
                child: _getRevenueCards(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _getInvoicesTable(false),
              ),
              Expanded(
                flex: 2,
                child: _getReceiptsTable(false),
              ),
            ],
          )
        ],
      ),
    );
    return getView(context);
  }

  List<ModulePageMenu> _pagesMenu(BuildContext context) {
    return [
      ModulePageMenu(
        name: 'Create retail sale',
        link: '/sales/cash',
        icon: Icons.storefront_sharp,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            widget.onChangePage(SalesCashRetail(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Create wholesale',
        link: '/sales/cash',
        icon: Icons.business,
        svgName: 'product_icon.svg',
        roles: [],
        onClick: () =>
            widget.onChangePage(SalesCashWhole(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Create invoices',
        link: '/sales/invoice',
        icon: Icons.receipt_long,
        svgName: 'invoice_icon.svg',
        roles: [],
        onClick: () =>
            widget.onChangePage(InvoiceSalePage(onBackPage: widget.onBackPage)),
      ),
      ModulePageMenu(
        name: 'Customers',
        link: '/sales/customers',
        svgName: 'customers_icon.svg',
        icon: Icons.supervised_user_circle_outlined,
        roles: [],
        onClick: () =>
            widget.onChangePage(CustomersPage(onBackPage: widget.onBackPage)),
      ),
    ];
  }

  @override
  void dispose() {
    if (_locationSubscriptionStream != null) {
      _locationSubscriptionStream?.cancel();
    }
    super.dispose();
  }

  Widget _getRevenueCards() {
    var totalCash = Expanded(
      flex: 1,
      child: NumberCard(
        "Total cash",
        doubleOrZero(_getIt('cash_total', data)),
        null,
      ),
    );
    var invoiceSale = Expanded(
      flex: 1,
      child: NumberCard(
        "Expenses",
        doubleOrZero(_getIt('expense', data)),
        null,
        isDanger: true,
        // onClick: () => _pageNav(
        //   InvoicesPage(
        //     onGetModulesMenu: widget.onGetModulesMenu,
        //   ),
        // ),
      ),
    );
    var cashSales = Expanded(
      flex: 1,
      child: NumberCard(
        "Cash sales",
        doubleOrZero(_getIt('cash_sale', data)),
        null,
        onClick: () => widget.onChangePage(
          SalesCashPage(
            onBackPage: widget.onBackPage,
            onChangePage: widget.onChangePage,
          ),
        ),
      ),
    );
    var invoiceSales = Expanded(
      flex: 1,
      child: NumberCard(
        "Invoice sales",
        doubleOrZero(_getIt('invoice_sale', data)),
        null,
        onClick: () => widget.onChangePage(InvoicesPage(
          onBackPage: widget.onBackPage,
          onChangePage: widget.onChangePage,
        )),
      ),
    );
    var paidInvoice = Expanded(
      flex: 1,
      child: NumberCard(
        "Invoice paid",
        doubleOrZero(_getIt('invoice_paid', data)),
        null,
        // onClick: () => _pageNav(
        //   InvoicesPage(
        //     onGetModulesMenu: widget.onGetModulesMenu,
        //   ),
        // ),
      ),
    );
    var totalSales = Expanded(
      flex: 1,
      child: NumberCard(
        "Total sales",
        doubleOrZero(_getIt('invoice_sale', data)) +
            doubleOrZero(_getIt('cash_sale', data)),
        null,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: BodyLarge(text: "Today's revenue"),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [cashSales, invoiceSales],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [invoiceSale, paidInvoice],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [totalSales, totalCash],
        )
      ],
    );
  }

  Widget _getSoldItemsTable(isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  flex: 1, child: BodyLarge(text: "Latest sold items")),
              const WhiteSpacer(width: 8),
              OutlinedButton(
                  onPressed: () {
                    widget.onChangePage(SoldItemsPage(
                        onBackPage: widget.onBackPage,
                        onChangePage: widget.onChangePage));
                  },
                  child: const BodyLarge(text: 'View More'))
            ],
          ),
          const WhiteSpacer(height: 8),
          const Divider(),
          const SizedBox(
            child: TableLikeListRow([
              TableLikeListHeaderCell('Item'),
              TableLikeListHeaderCell('Quantity'),
              TableLikeListHeaderCell('Amount ( TZS )'),
            ]),
          ),
          ...itOrEmptyArray(data['sold_items']).map((e) {
            return SizedBox(
              // height: 38,
              child: TableLikeListRow([
                TableLikeListTextDataCell("${e['name']}"),
                TableLikeListTextDataCell('${e['quantity']}'),
                TableLikeListTextDataCell(
                    formatNumber('${e['amount'] ?? '0'}')),
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _getReceiptsTable(isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  flex: 1, child: BodyLarge(text: "Latest receipts")),
              const WhiteSpacer(width: 8),
              OutlinedButton(
                  onPressed: () {
                    widget.onChangePage(SalesCashPage(
                        onBackPage: widget.onBackPage,
                        onChangePage: widget.onChangePage));
                  },
                  child: const BodyLarge(text: 'View More'))
            ],
          ),
          const WhiteSpacer(height: 8),
          const Divider(),
          const SizedBox(
            child: TableLikeListRow([
              TableLikeListHeaderCell('Customer'),
              TableLikeListHeaderCell('Amount'),
              TableLikeListHeaderCell('Items'),
            ]),
          ),
          ...itOrEmptyArray(data['sales_cash']).map((e) {
            return SizedBox(
              // height: 38,
              child: TableLikeListRow([
                TableLikeListTextDataCell('${e['customer'] ?? ''}'.isEmpty
                    ? 'Walk in customer'
                    : e['customer']),
                TableLikeListTextDataCell(
                    formatNumber('${e['amount'] ?? '0'}')),
                TableLikeListTextDataCell(formatNumber('${_itemsSize(e)}')),
              ]),
            );
          }),
        ],
      ),
    );
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

  Widget _getInvoicesTable(isSmallScreen) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                  flex: 1, child: BodyLarge(text: "Latest invoices")),
              const WhiteSpacer(width: 8),
              OutlinedButton(
                  onPressed: () {
                    widget.onChangePage(InvoicesPage(
                        onBackPage: widget.onBackPage,
                        onChangePage: widget.onChangePage));
                  },
                  child: const BodyLarge(text: 'View More'))
            ],
          ),
          const WhiteSpacer(height: 8),
          const Divider(),
          const SizedBox(
            child: TableLikeListRow([
              TableLikeListHeaderCell('Customer'),
              TableLikeListHeaderCell('Amount'),
              TableLikeListHeaderCell('Status'),
            ]),
          ),
          ...itOrEmptyArray(data['sales_invoice']).map((e) {
            return SizedBox(
              // height: 38,
              child: TableLikeListRow([
                TableLikeListTextDataCell("${_getCustomer(e)}"),
                TableLikeListTextDataCell('${e['amount']}'),
                _getStatusView(e),
              ]),
            );
          }),
        ],
      ),
    );
  }

  _getCustomer(e) {
    return compose([
      propertyOr('displayName', (p0) => 'Walk in customer'),
      propertyOrNull('customer')
    ])(e);
  }

  _getStatusView(invoice) {
    var amount = doubleOrZero(invoice['amount']);
    var paidView = Container(
      height: 34,
      width: 76,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: const LabelLarge(text: "Paid", overflow: TextOverflow.ellipsis),
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
        height: 34,
        width: 76,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: LabelLarge(
            text: "${formatNumber((paid * 100) / amount, decimals: 0)}%",
            overflow: TextOverflow.ellipsis),
      );
    }
  }

  void _listeningForLocation() {
    listener(Position? position) {
      if (position != null) {
        updateShopLocation(
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
        ).then((value) {
          if (kDebugMode) {
            print(value);
          }
        }).catchError((error) {
          if (kDebugMode) {
            print(error);
          }
        });
      }
    }

    _locationSubscriptionStream = getLocationChangeStream().listen(listener);
  }

  _getIt(String s, Map<dynamic, dynamic> data) {
    return propertyOrNull(s)(data);
  }
}
