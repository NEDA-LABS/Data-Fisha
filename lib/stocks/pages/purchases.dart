import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/purchase_details.dart';
import 'package:smartstock/stocks/pages/purchase_create.dart';
import 'package:smartstock/stocks/services/purchase.dart';

class PurchasesPage extends StatefulWidget {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const PurchasesPage({
    Key? key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PurchasesPage();
}

class _PurchasesPage extends State<PurchasesPage> {
  bool _loading = false;
  List _purchases = [];
  final String _startAt = toSqlDate(DateTime.now());

  _appBar(context) => SliverSmartStockAppBar(
      title: "Purchases",
      showBack: true,
      backLink: '/stock/',
      showSearch: false,
      onBack: widget.onBackPage,
      searchHint: 'Search...',
      context: context);

  _contextPurchases(context) => [
        ContextMenu(
          name: 'Create',
          pressed: () {
            widget.onChangePage(
                PurchaseCreatePage(onBackPage: widget.onBackPage));
          },
        ),
        ContextMenu(name: 'Reload', pressed: () => _refresh())
      ];

  _tableHeader() => const TableLikeListRow([
        TableLikeListTextHeaderCell('Reference'),
        TableLikeListTextHeaderCell('Date'),
        TableLikeListTextHeaderCell('Cost ( TZS )'),
        TableLikeListTextHeaderCell('Paid ( TZS )'),
        Center(child: TableLikeListTextHeaderCell('Status')),
      ]);

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/stock/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextPurchases(context)),
          _loadingView(_loading),
          getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        loading: _loading,
        onLoadMore: () async {
          _loadMore();
        },
        fab: FloatingActionButton(
          onPressed: () => _showMobileContextMenu(context),
          child: const Icon(Icons.unfold_more_outlined),
        ),
        totalDynamicChildren: _purchases.length,
        dynamicChildBuilder: getIsSmallScreen(context)
            ? _smallScreenChildBuilder
            : _largerScreenChildBuilder,
      );

  _refresh() {
    setState(() {
      _loading = true;
    });
    getPurchasesRemote(_startAt).then((value) {
      _purchases = value;
    }).whenComplete(() {
      if(mounted){
        setState(() {
          _loading = false;
        });
      }
    });
  }

  _loadMore() {
    if (_purchases.isNotEmpty) {
      var last = _purchases.last;
      setState(() {
        _loading = true;
      });
      var updatedAt = last['updatedAt'] ?? toSqlDate(DateTime.now());
      getPurchasesRemote(updatedAt).then((value) {
        _purchases.addAll(value);
      }).whenComplete(() {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Widget _smallScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => showDialogOrModalSheet(
              purchaseDetails(context, _purchases[index]), context),
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableLikeListTextDataCell('${_purchases[index]['refNumber']}'),
              _getStatusView(_purchases[index])
            ],
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_purchases[index]['date']}'),
                  Text(
                      'total ${compactNumber('${_purchases[index]['amount']}')}'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${_purchases[index]['supplier']}',
                  style: const TextStyle(fontSize: 13),
                ),
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
              purchaseDetails(context, _purchases[index]), context),
          child: TableLikeListRow([
            TableLikeListTextDataCell('${_purchases[index]['refNumber']}'),
            TableLikeListTextDataCell(
                '${toSqlDate(DateTime.tryParse(_purchases[index]['date']) ?? DateTime.now())}'),
            TableLikeListTextDataCell(
                '${formatNumber(_purchases[index]['amount'])}'),
            TableLikeListTextDataCell('${_getInvPayment(_purchases[index])}'),
            Center(child: _getStatusView(_purchases[index]))
          ]),
        ),
        const HorizontalLine()
      ],
    );
  }

  _getInvPayment(purchase) {
    if (purchase is Map) {
      var type = purchase['type'];
      if (type == 'invoice') {
        var payments = purchase['payments'];
        if (payments is List) {
          var a = payments.fold(0,
              (dynamic a, element) => a + doubleOrZero('${element['amount']}'));
          return formatNumber(a);
        }
      } else {
        return formatNumber(purchase['amount'] ?? 0);
      }
    }
    return 0;
  }

  _getStatusView(purchase) {
    var tStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C));
    var type = purchase['type'];
    var amount = purchase['amount'];
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
      var payments = purchase['payments'];
      if (payments is List) {
        return payments.fold(0,
            (dynamic a, element) => a + doubleOrZero('${element['amount']}'));
      }
      return 0;
    }

    if (type == 'invoice') {
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
          child: Text("Partial", style: tStyle),
        );
      }
    }
    return paidView;
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
                title: const Text('Record purchase'),
                onTap: () {
                  widget.onChangePage(
                    PurchaseCreatePage(
                      onBackPage: widget.onBackPage,
                    ),
                  );
                  Navigator.of(context).maybePop();
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload purchases'),
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
