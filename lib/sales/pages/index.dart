import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/SwitchToPageMenu.dart';
import 'package:smartstock/core/components/SwitchToTitle.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/numberCard.dart';
import 'package:smartstock/sales/pages/sales_cash_whole.dart';
import 'package:smartstock/sales/pages/sales_cash.dart';
import 'package:smartstock/sales/pages/sales_cash_retail.dart';
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

  @override
  void initState() {
    _fetchSummary();
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
      sliverAppBar: getSliverSmartStockAppBar(
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
      if(mounted){
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
      child: NumberPercentageCard(
        "Total cash",
        doubleOrZero(_getIt('cash_total', data)),
        null,
      ),
    );
    var invoiceSale = Expanded(
      flex: 1,
      child: NumberPercentageCard(
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
      child: NumberPercentageCard(
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
      child: NumberPercentageCard(
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
      child: NumberPercentageCard(
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
      child: NumberPercentageCard(
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
          )
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
            mainAxisSize: MainAxisSize.min,
            children: [totalSales, paidInvoice],
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
}
