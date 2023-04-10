import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/core/components/BodySmall.dart';
import 'package:smartstock/core/components/Histogram.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/models/HistogramData.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/dashboard/components/numberCard.dart';
import 'package:smartstock/stocks/services/stocks_report.dart';

Widget _expandedByOne({required Widget child}) {
  return Expanded(
    flex: 1,
    child: child,
  );
}

Widget _getItemQuantities(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        'Items quantity', summary['values']?['items_quantity_positive'], 0),
  );
}

Widget _getItemPurchaseValue(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        'Purchase value', summary['values']?['purchase_value'], 0),
  );
}

Widget _getRetailValue(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        'Retail value', summary['values']?['retail_value'], 0),
  );
}

Widget _getWholesaleValue(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
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

Widget _getProductsTotal(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard('Products', summary['values']?['items'], 0),
  );
}

class StocksSummary extends StatefulWidget {
  const StocksSummary({Key? key}) : super(key: key);

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
      setState(() {
        loading = false;
      });
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
            ? _getProductsCompactScreen(summary)
            : _getProductsLargeScreen(summary),
        space,
        const BodySmall(text: 'Group by categories'),
        space,
        getGroups(summary).isNotEmpty
            ? Histogram(
                height: 230,
                data: getGroups(summary).map((e) {
                  return HistogramData(
                      x: e['name'], y: '${e['total']}', name: e['name']);
                }).toList(),
              )
            : Container(),
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
                    _getNearToExpire(summary),
                    _getExpired(summary),
                  ],
                )
              ]
            : [
                Row(
                  children: [
                    _get30DaysPurchase(summary),
                    _getDuePurchases(summary),
                    _getNearToExpire(summary),
                    _getExpired(summary),
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

  List getGroups(Map summary) {
    List list = summary['group'] is List ? summary['group'] as List : [];
    return list;
  }
}

Widget _getExpired(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
      'Expired',
      summary['purchases']?['expired'],
      0,
      isDanger: true,
    ),
  );
}

Widget _getNearToExpire(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        'Near to expired', summary['purchases']?['expire_next_3_month'], 0,
        isWarning: true),
  );
}

Widget _getDuePurchases(Map summary) {
  return Expanded(
    flex: 1,
    child: NumberPercentageCard(
      'Due purchases',
      summary['purchases']?['purchases_due'],
      0,
      isDanger: true,
    ),
  );
}

Widget _get30DaysPurchase(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        '30 days purchase', summary['purchases']?['purchases_past_month'], 0),
  );
}

List<Widget> _getProductsLargeScreen(Map summary) {
  return [
    Row(
      children: [
        _getProductsTotal(summary),
        _getProductsPositive(summary),
        _getProductsZero(summary),
        _getProductsNegative(summary),
      ],
    )
  ];
}

List<Widget> _getProductsCompactScreen(Map summary) {
  return [
    Row(
      children: [_getProductsTotal(summary), _getProductsPositive(summary)],
    ),
    Row(
      children: [_getProductsZero(summary), _getProductsNegative(summary)],
    )
  ];
}

Widget _getProductsNegative(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
      'Negative products',
      summary['values']?['items_negative'],
      0,
      isDanger: true,
    ),
  );
}

Widget _getProductsZero(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
      'Zero products',
      summary['values']?['items_zero'],
      0,
      isWarning: true,
    ),
  );
}

Widget _getProductsPositive(Map summary) {
  return _expandedByOne(
    child: NumberPercentageCard(
        'Positive products', summary['values']?['items_positive'], 0),
  );
}
