import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/Histogram.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/models/HistogramData.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/NumberCard.dart';
import 'package:smartstock/stocks/pages/products.dart';
import 'package:smartstock/stocks/services/inventories_filters.dart';
import 'package:smartstock/stocks/services/stocks_report.dart';

class StocksSummary extends StatefulWidget {
  final OnChangePage onChangePage;
  final OnBackPage onBackPage;

  const StocksSummary({
    Key? key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StocksSummary> {
  bool loading = false;
  Map summary = {};

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    getStockIndexReport().then((value) {
      summary = value;
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    }).whenComplete(() {
      if(mounted){
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var space = const WhiteSpacer(height: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _title(),
        ...isSmallScreen
            ? _getItemValueCompactScreenView(summary)
            : _getItemValueLargeScreen(summary),
        ...isSmallScreen
            ? _getProductsCompactScreen(summary, context)
            : _getProductsLargeScreen(summary, context),
        space,
        // const BodySmall(text: 'Group by categories'),
        // space,
        // _getGroups(summary).isNotEmpty
        //     ? Histogram(
        //         height: 230,
        //         data: _getGroups(summary).map((e) {
        //           return HistogramData(
        //               x: e['name'], y: '${e['total']}', name: e['name']);
        //         }).toList(),
        //       )
        //     : Container(),
        ...isSmallScreen
            ? [
                Row(
                  children: [
                    _get30DaysPurchase(summary),
                    _getDuePurchases(summary)
                  ],
                ),
                Row(
                  children: [
                    _getNearToExpire(summary, context),
                    _getExpired(summary, context),
                  ],
                )
              ]
            : [
                Row(
                  children: [
                    _get30DaysPurchase(summary),
                    _getDuePurchases(summary),
                    _getNearToExpire(summary, context),
                    _getExpired(summary, context),
                  ],
                )
              ],
      ],
    );
  }

  _title() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: BodySmall(text: "Summary"),
    );
  }

  List _getGroups(Map summary) {
    List list = summary['group'] is List ? summary['group'] as List : [];
    return list;
  }

  Widget _expandedByOne({required Widget child}) {
    return Expanded(
      flex: 1,
      child: child,
    );
  }

  Widget _getItemQuantities(Map summary) {
    return _expandedByOne(
      child: NumberCard(
          'Items quantity', summary['values']?['items_quantity_positive'], 0),
    );
  }

  Widget _getItemPurchaseValue(Map summary) {
    return _expandedByOne(
      child: NumberCard(
          'Purchase value', summary['values']?['purchase_value'], 0),
    );
  }

  Widget _getRetailValue(Map summary) {
    return _expandedByOne(
      child: NumberCard(
          'Retail value', summary['values']?['retail_value'], 0),
    );
  }

  Widget _getWholesaleValue(Map summary) {
    return _expandedByOne(
      child: NumberCard(
          'Wholesale value', summary['values']?['wholesale_value'], 0),
    );
  }

  List<Widget> _getItemValueCompactScreenView(Map summary) {
    return [
      Row(
        children: [
          _getItemQuantities(summary),
          _getItemPurchaseValue(summary),
        ],
      ),
      Row(
        children: [
          _getRetailValue(summary),
          _getWholesaleValue(summary),
        ],
      )
    ];
  }

  List<Widget> _getItemValueLargeScreen(Map summary) {
    return [
      Row(
        children: [
          _getItemQuantities(summary),
          _getItemPurchaseValue(summary),
          _getRetailValue(summary),
          _getWholesaleValue(summary),
        ],
      )
    ];
  }

  Widget _getProductsTotal(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Products',
        summary['values']?['items'],
        0,
        onClick: () {
          widget.onChangePage(ProductsPage(
            onBackPage: widget.onBackPage,
            onChangePage: widget.onChangePage,
          ));
        },
      ),
    );
  }

  Widget _getExpired(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Expired',
        summary['purchases']?['expired'],
        0,
        isDanger: true,
        onClick: () {
          widget.onChangePage(
            ProductsPage(
              onBackPage: widget.onBackPage,
              onChangePage: widget.onChangePage,
              initialFilter: getExpiredProductsFilter('expired'),
            ),
          );
        },
      ),
    );
  }

  Widget _getNearToExpire(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Near to expired',
        summary['purchases']?['expire_next_3_month'],
        0,
        isWarning: true,
        onClick: () {
          widget.onChangePage(
            ProductsPage(
              onBackPage: widget.onBackPage,
              onChangePage: widget.onChangePage,
              initialFilter: getExpiredProductsFilter('near_expired'),
            ),
          );
        },
      ),
    );
  }

  Widget _getDuePurchases(Map summary) {
    return Expanded(
      flex: 1,
      child: NumberCard(
        'Due purchases',
        summary['purchases']?['purchases_due'],
        0,
        isDanger: true,
      ),
    );
  }

  Widget _get30DaysPurchase(Map summary) {
    return _expandedByOne(
      child: NumberCard(
          '30 days purchase', summary['purchases']?['purchases_past_month'], 0),
    );
  }

  List<Widget> _getProductsLargeScreen(Map summary, BuildContext context) {
    return [
      Row(
        children: [
          _getProductsTotal(summary, context),
          _getProductsPositive(summary, context),
          _getProductsZero(summary, context),
          _getProductsNegative(summary, context),
        ],
      )
    ];
  }

  List<Widget> _getProductsCompactScreen(Map summary, BuildContext context) {
    return [
      Row(
        children: [
          _getProductsTotal(summary, context),
          _getProductsPositive(summary, context)
        ],
      ),
      Row(
        children: [
          _getProductsZero(summary, context),
          _getProductsNegative(summary, context)
        ],
      )
    ];
  }

  Widget _getProductsNegative(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Negative products',
        summary['values']?['items_negative'],
        0,
        isDanger: true,
        onClick: () {
          widget.onChangePage(
            ProductsPage(
              onBackPage: widget.onBackPage,
              onChangePage: widget.onChangePage,
              initialFilter: getNegativeProductFilter('negative'),
            ),
          );
        },
      ),
    );
  }

  Widget _getProductsZero(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Zero products',
        summary['values']?['items_zero'],
        0,
        isWarning: true,
        onClick: () {
          widget.onChangePage(
            ProductsPage(
              onBackPage: widget.onBackPage,
              onChangePage: widget.onChangePage,
              initialFilter: getZeroProductsFilter('zeros'),
            ),
          );
        },
      ),
    );
  }

  Widget _getProductsPositive(Map summary, BuildContext context) {
    return _expandedByOne(
      child: NumberCard(
        'Positive products',
        summary['values']?['items_positive'],
        0,
        onClick: () {
          widget.onChangePage(
            ProductsPage(
              onBackPage: widget.onBackPage,
              onChangePage: widget.onChangePage,
              initialFilter: getPositiveProductsFilter('positives'),
            ),
          );
        },
      ),
    );
  }
}
