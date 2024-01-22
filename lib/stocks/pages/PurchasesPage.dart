import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/debounce.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/search_by_container.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/stocks/components/PurchaseDetails.dart';
import 'package:smartstock/stocks/pages/purchase_create.dart';
import 'package:smartstock/stocks/services/purchase.dart';

class PurchasesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const PurchasesPage({
    super.key,
    required this.onChangePage,
    required this.onBackPage,
  }) : super(pageName: 'PurchasesPage');

  @override
  State<StatefulWidget> createState() => _PurchasesPage();
}

class _PurchasesPage extends State<PurchasesPage> {
  final _debounce = Debounce(milliseconds: 1000);
  bool _loading = false;
  List<dynamic> _purchases = [];
  String _query = '';
  final String _startAt = toSqlDate(DateTime.now());
  Map<String, String> _searchByMap = {
    'name': "Reference",
    'value': 'ref_number'
  };

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Purchases",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onBack: widget.onBackPage,
      searchByView: SearchByContainer(
        filters: [
          SearchByFilter(
              child: const BodyLarge(text: "Reference"),
              value: {'name': "Reference", 'value': 'ref_number'}),
          SearchByFilter(
              child: const BodyLarge(text: "Purchase date"),
              value: {'name': "Date", 'value': 'date'}),
          SearchByFilter(
              child: const BodyLarge(text: "Supplier"),
              value: {'name': "Supplier", 'value': 'supplier'}),
          SearchByFilter(
              child: const BodyLarge(text: "Type"),
              value: {'name': "Type", 'value': 'type'})
        ],
        currentValue: _searchByMap['name'] ?? '',
        onUpdate: (searchMap) {
          _updateState(() {
            _searchByMap = searchMap;
          });
          // _query='';
          _refresh();
        },
      ),
      onSearch: (d) {
        _debounce.run(() {
          _query = d;
          _refresh();
        });
      },
      searchHint: 'Type to search',
      context: context,
    );
  }

  _contextPurchases(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () {
          widget
              .onChangePage(PurchaseCreatePage(onBackPage: widget.onBackPage));
        },
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh())
    ];
  }

  _tableHeader() {
    return TableLikeListRow([
      const LabelSmall(text: 'REFERENCE'),
      const LabelSmall(text: 'DATE'),
      WithActiveShop(
          onChild: (shop) =>
              LabelSmall(text: 'COST ( ${shop['settings']?['currency']} )')),
      WithActiveShop(
          onChild: (shop) =>
              LabelSmall(text: 'PAID ( ${shop['settings']?['currency']} )')),
      const Center(child: LabelSmall(text: 'STATUS')),
      const Center(child: LabelSmall(text: 'REVIEW')),
      const Center(child: LabelSmall(text: 'ACTION')),
    ]);
  }

  _loadingView(bool show) {
    return show ? const LinearProgressIndicator(minHeight: 4) : Container();
  }

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    var isSmallScreen = getIsSmallScreen(context);
    return ResponsivePage(
      current: '/stock/purchases',
      sliverAppBar: _appBar(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      staticChildren: [
        isSmallScreen
            ? Container()
            : getTableContextMenu(_contextPurchases(context)),
        _loadingView(_loading),
        isSmallScreen ? Container() : _tableHeader(),
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
  }

  _refresh() {
    _updateState(() {
      _loading = true;
    });
    productsGetPurchases(
      startAt: _startAt,
      filterValue: _query,
      filterBy: _searchByMap['value'],
    ).then((value) {
      _purchases = value;
    }).whenComplete(() {
      if (mounted) {
        _updateState(() {
          _loading = false;
        });
      }
    });
  }

  _loadMore() {
    if (_purchases.isNotEmpty) {
      var last = _purchases.last;
      _updateState(() {
        _loading = true;
      });
      var updatedAt = last['updatedAt'] ?? toSqlDate(DateTime.now());
      productsGetPurchases(
        startAt: updatedAt,
        filterValue: _query,
        filterBy: _searchByMap['value'],
      ).then((value) {
        _purchases.addAll(value);
      }).whenComplete(() {
        _updateState(() {
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
        const WhiteSpacer(height: 5),
        ListTile(
          dense: true,
          onTap: () {
            // showDialogOrModalSheet(
            //     PurchaseDetails(context, _purchases[index]), context)
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyLarge(
                text: '${_purchases[index]['refNumber']}',
                overflow: TextOverflow.ellipsis,
              ),
              const WhiteSpacer(width: 8),
              _getStatusView(_purchases[index])
            ],
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WhiteSpacer(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelMedium(text: '${_purchases[index]['date']}'),
                  const WhiteSpacer(width: 8),
                  LabelMedium(
                      text:
                          'Total ${formatNumber('${_purchases[index]['amount']}', decimals: 0)}'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: LabelMedium(text: '${_purchases[index]['supplier']}'),
              ),
            ],
          ),
        ),
        const HorizontalLine(),
      ],
    );
  }

  Widget _largerScreenChildBuilder(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableLikeListRow([
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyLarge(text: '${_purchases[index]['refNumber']}'),
              LabelMedium(text: _purchases[index]['supplier'] ?? '')
            ],
          ),
          TableLikeListTextDataCell(
              '${toSqlDate(DateTime.tryParse(_purchases[index]['date']) ?? DateTime.now())}'),
          TableLikeListTextDataCell(
              '${formatNumber(_purchases[index]['amount'])}'),
          TableLikeListTextDataCell('${_getInvPayment(_purchases[index])}'),
          Center(child: _getStatusView(_purchases[index])),
          Center(child: _getVerifiedForLargeScreen(_purchases[index])),
          Center(
            child: InkWell(
              onTap: () => {
                showDialogOrModalSheet(
                  PurchaseDetails(
                    item: _purchases[index],
                    onDoneVerify: (data) {
                      _updateState(() {
                        _purchases[index] = {
                          ..._purchases[index] as Map,
                          'metadata': {
                            ..._purchases[index]['metadata'] as Map,
                            ...data
                          }
                        };
                      });
                    },
                    onDoneUpdate: (data) {
                      _updateState(() {
                        _purchases[index] = {
                          ..._purchases[index] as Map,
                          'images': data['images']
                        };
                      });
                    },
                    onDonePayment: (data) {
                      _updateState(() {
                        _purchases[index] = {
                          ..._purchases[index] as Map,
                          'payments': [
                            ...itOrEmptyArray(_purchases[index]['payments']),
                            data
                          ]
                        };
                      });
                    },
                    onDoneDelete: (data) {
                      _updateState(() {
                        _purchases.removeAt(index);
                      });
                      Navigator.of(context).maybePop();
                    },
                  ),
                  context,
                )
              },
              child: LabelLarge(
                text: 'Manage',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ]),
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
    // var tStyle = const TextStyle(fontSize: 14, color: Color(0xFF1C1C1C));
    var type = purchase['type'];
    var amount = purchase['amount'];
    var paidView = Container(
      height: 24,
      width: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: const LabelMedium(text: "Paid"),
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
          width: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: LabelMedium(
              text:
                  "Paid ${formatNumber((paid / amount) * 100, decimals: 0)}%"),
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
                title: const Text('Reload'),
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

  void _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _getVerifiedForLargeScreen(purchase) {
    var getVerified =
        compose([propertyOrNull('verified'), propertyOrNull('metadata')]);
    var verified = getVerified(purchase);
    if (verified == true) {
      return Tooltip(
        message: "Purchase verified",
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: Theme.of(context).colorScheme.primary),
          child: Center(
              child: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onPrimary,
          )),
        ),
      );
    } else {
      return Tooltip(
        message: "Purchase not verified",
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            // color: Theme.of(context).colorScheme.error,
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: Center(
              child: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onSurface,
          )),
        ),
      );
    }
  }
}
