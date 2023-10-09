import 'dart:async';

import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/HeadineMedium.dart';
import 'package:smartstock/core/components/HeadineSmall.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/api_shop.dart';
import 'package:smartstock/core/services/location.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/number_card.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/pages/sales_invoice.dart';
import 'package:smartstock/sales/pages/sales_invoice_retail.dart';
import 'package:smartstock/sales/services/index.dart';

import 'customers.dart';

class SalesPage extends StatefulWidget {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const SalesPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key);

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
    _locationSubscriptionStream =
        getLocationChangeStream().listen((Position? position) {
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
      // // if (kDebugMode) {
      // print(position == null
      //     ? 'Unknown'
      //     : 'Location: ${position.latitude.toString()}, ${position.longitude.toString()}');
      // // }
    });
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      office: 'Menu',
      current: '/sales/',
      staticChildren: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            loading ? const LinearProgressIndicator() : Container(),
            const SwitchToTitle(),
            SwitchToPageMenu(pages: _pagesMenu(context)),
            const WhiteSpacer(height: 16),
            const BodySmall(text: 'Summary'),
            const WhiteSpacer(height: 8),
            _getTotalSalesView(context),
          ],
        )
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

  _getIt(String p, data) => data is Map ? data[p] : null;

  _getTotalSalesView(BuildContext context) {
    var cashSale = Expanded(
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
        "Unpaid invoices",
        doubleOrZero(_getIt('invoice_unpaid', data)),
        null,
        isDanger: true,
        // onClick: () => _pageNav(
        //   InvoicesPage(
        //     onGetModulesMenu: widget.onGetModulesMenu,
        //   ),
        // ),
      ),
    );
    var expenses = Expanded(
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
    var profit = Expanded(
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
    var getView = ifDoElse(
      (context) => getIsSmallScreen(context),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [expenses, profit],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [cashSale, invoiceSale],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [totalSales, paidInvoice],
          ),
          _getSoldItemsTable(true),
        ],
      ),
      (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              expenses,
              profit,
              cashSale,
              invoiceSale,
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _getSoldItemsTable(false),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      totalSales,
                      paidInvoice,
                    ],
                  ),
                ),
              )
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
          const BodyLarge(text: "Sold Items"),
          const WhiteSpacer(height: 8),
          const Divider(),
          SizedBox(
            child: isSmallScreen == true
                ? const TableLikeListRow([
                    TableLikeListTextHeaderCell('Item'),
                    TableLikeListTextHeaderCell('Quantity'),
                    TableLikeListTextHeaderCell('Amount ( TZS )'),
                  ])
                : const TableLikeListRow([
                    TableLikeListTextHeaderCell('Item'),
                    TableLikeListTextHeaderCell('Quantity'),
                    TableLikeListTextHeaderCell('Amount ( TZS )'),
                    TableLikeListTextHeaderCell('Purchase ( TZS )'),
                  ]),
          ),
          ...itOrEmptyArray(data['sold_items']).map((e) {
            return SizedBox(
              // height: 38,
              child: isSmallScreen == true
                  ? TableLikeListRow([
                      TableLikeListTextDataCell("${e['name']}"),
                      TableLikeListTextDataCell('${e['quantity']}'),
                      TableLikeListTextDataCell(
                          formatNumber('${e['amount'] ?? '0'}')),
                    ])
                  : TableLikeListRow([
                      TableLikeListTextDataCell("${e['name']}"),
                      TableLikeListTextDataCell('${e['quantity']}'),
                      TableLikeListTextDataCell(
                          formatNumber('${e['amount'] ?? '0'}')),
                      TableLikeListTextDataCell(
                          formatNumber('${e['purchase_price'] ?? '0'}')),
                    ]),
            );
          }),
          itOrEmptyArray(data['sold_items']).length > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                        onPressed: () {},
                        child: const BodyLarge(text: 'View More'))
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
