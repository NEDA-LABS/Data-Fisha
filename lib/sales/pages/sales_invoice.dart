import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/invoice_details.dart';
import 'package:smartstock/sales/components/sale_invoice_details.dart';
import 'package:smartstock/sales/services/invoice.dart';

class InvoicesPage extends StatefulWidget {
final OnGetModulesMenu onGetModulesMenu;
  const InvoicesPage({Key? key, required this.onGetModulesMenu}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InvoicesPage();
}

class _InvoicesPage extends State<InvoicesPage> {
  bool _loading = false;

  // String _query = '';
  int size = 20;
  List _invoices = [];

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Invoices",
      showBack: true,
      backLink: '/sales/',
      showSearch: false,
      onBack: (){
        Navigator.of(context).maybePop();
      },
      // onSearch: (d) {
      //   setState(() {
      //     _query = d;
      //   });
      //   _refresh();
      // },
      // searchHint: 'Search by date...',
      context: context,
    );
  }

  _contextInvoices(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () => navigateTo('/sales/invoice/create'),
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    var height = 38.0;
    return SizedBox(
      height: height,
      child: const TableLikeListRow([
        TableLikeListTextHeaderCell('Customer'),
        TableLikeListTextHeaderCell('Date'),
        TableLikeListTextHeaderCell('Amount ( TZS )'),
        TableLikeListTextHeaderCell('Paid ( TZS )'),
        TableLikeListTextHeaderCell('Status'),
      ]),
    );
  }

  // _fields() => isSmallScreen(context)
  //     ? ['date', 'amount', 'customer']
  //     : ['date', 'amount', 'payment', 'customer'];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      menus: widget.onGetModulesMenu(context),
      current: '/sales/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        getIsSmallScreen(context)
            ? Container()
            : tableContextMenu(_contextInvoices(context)),
        _loadingView(_loading),
        getIsSmallScreen(context) ? Container() : _tableHeader(),
      ],
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined),
      ),
      totalDynamicChildren: _invoices.length,
      dynamicChildBuilder: getIsSmallScreen(context)
          ? _smallScreenChildBuilder
          : _largerScreenChildBuilder,
      loading: _loading,
      onLoadMore: () async => _loadMore(),
      // onBody: (d) {
      //   return Scaffold(
      //     body: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         tableContextMenu(_contextInvoices(context)),
      //         _loadingView(_loading),
      //         _tableHeader(),
      //         Expanded(
      //           child: TableLikeList(
      //             onFuture: () async => _invoices,
      //             keys: _fields(),
      //             onLoadMore: () async => _loadMore(),
      //             loading: _loading,
      //             onCell: (a, b, c) {
      //               if (a == 'date') {
      //                 return _dateView(c);
      //               }
      //               if (a == 'customer') {
      //                 return Text('${b['displayName']}');
      //               }
      //               if (a == 'payment') {
      //                 return Text('${_getInvPayment(b)}');
      //               }
      //               return Text('$b');
      //             },
      //             onItemPressed: (item) {
      //               showDialogOrModalSheet(
      //                 SaleInvoiceDetail(sale: item, pageContext: context),
      //                 context,
      //               );
      //               // showDialogOrModalSheet(
      //               //   invoiceDetails(context, item),
      //               //   context,
      //               // );
      //             },
      //           ),
      //         ), // _tableFooter()
      //       ],
      //     ),
      //   );
      // },
    );
  }

  _loadMore() {
    setState(() {
      _loading = true;
    });
    var getInvoices = _prepareGetInvoices('', size, true);
    getInvoices(_invoices).then((value) {
      if (value is List) {
        _invoices.addAll(value);
        _invoices = _invoices.toSet().toList();
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _prepareGetInvoices(String product, size, bool more) {
    return ifDoElse(
          (sales) => sales is List && sales.isNotEmpty,
          (sales) {
        var last = more ? sales.last['timer'] : _defaultLast();
        return getInvoiceSalesFromCacheOrRemote(last, size, product);
      },
          (sales) =>
          getInvoiceSalesFromCacheOrRemote(_defaultLast(), size, product),
    );
  }

  _refresh() {
    setState(() {
      _loading = true;
    });
    var getInvoices = _prepareGetInvoices('', size, false);
    getInvoices(_invoices).then((value) {
      if (value is List) {
        _invoices = value;
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

  final _getCustomer=compose([
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
                      'total ${compactNumber(
                          '${_invoices[index]['amount']}')}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        HorizontalLine(),
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
                '${toSqlDate(DateTime.tryParse(_invoices[index]['date']) ??
                    DateTime.now())}'),
            TableLikeListTextDataCell(
                '${formatNumber(_invoices[index]['amount'])}'),
            TableLikeListTextDataCell('${_getInvPayment(_invoices[index])}'),
            Center(child: _getStatusView(_invoices[index]))
          ]),
        ),
        HorizontalLine()
      ],
    );
  }

  _getInvPayment(invoice) {
    if (invoice is Map) {
      var payments = invoice['payments'];
      if (payments is List) {
        var a = payments.fold(0,
                (dynamic a, element) =>
            a + doubleOrZero('${element['amount']}'));
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
        color: const Color(0xFFadf0cc),
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text("Paid", style: tStyle),
    );
    getPayment() {
      var payments = invoice['payments'];
      if (payments is List) {
        return payments.fold(0,
                (dynamic a, element) =>
            a + doubleOrZero('${element['amount']}'));
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
          color: const Color(0xFFffed8a),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        child: Text("${formatNumber((paid * 100)/amount,decimals: 0)}%", style: tStyle),
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
                onTap: () => navigateTo('/sales/invoice/create'),
              ),
              HorizontalLine(),
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
