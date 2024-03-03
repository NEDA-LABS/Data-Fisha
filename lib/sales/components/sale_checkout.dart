import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/plugins/printer.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/printer.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/sales/services/customers.dart';
import 'package:smartstock/sales/services/invoice.dart';
import 'package:smartstock/sales/services/sales.dart';

_fn(dynamic d) => null;

class SaleCheckout extends StatefulWidget {
  final List<CartModel> carts;
  final Function(dynamic data) onDone;

  const SaleCheckout({required this.carts, this.onDone = _fn, super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SaleCheckout> {
  final String _batchId = generateUUID();
  bool verifying = false;
  bool _confirmingSale = false;
  Map _shop = {};
  Map _customer = {'id': 0, 'displayName': 'Walk In Customer'};
  Map _errors = {};
  String _discount = '0';
  String _tax = '0';
  Map _paymentMethod = {"name": "Cash", "value": "cash"};

  @override
  void initState() {
    getActiveShop().then((value) {
      _shop = value;
    }).catchError((e) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_confirmingSale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _getHeaderSection(top: 16),
          const WhiteSpacer(height: 8),
          const HorizontalLine(),
          Expanded(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverToBoxAdapter(
                    child: _getDetailSection(shop: _shop, top: 8)),
                // SliverToBoxAdapter(child: _getFilesSection()),
                SliverToBoxAdapter(child: _getItemsHeader(shop: _shop)),
                SliverList.list(children: _getItemsBody(shop: _shop)),
                const SliverToBoxAdapter(child: WhiteSpacer(height: 24))
              ],
            ),
          ),
          const HorizontalLine(),
          _getFooterSection(top: 16)
        ],
      ),
    );
  }

  Widget _sectionWrapper({
    required Widget child,
    required double top,
    Color? color,
    double radius = 0,
  }) {
    var hPadding = EdgeInsets.only(left: 24, right: 24, top: top);
    return Container(
      margin: hPadding,
      decoration: BoxDecoration(
        border: color != null ? Border.all(color: color) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: child,
    );
  }

  _getSaleAmount() {
    var total = widget.carts.fold(
      0.0,
      (a, b) => a + doubleOrZero(b.product['retailPrice']) * b.quantity,
    );
    return total - doubleOrZero(_discount);
  }

  // _getNetSaleAmount() {
  //   var gross = _getSaleAmount();
  //   var tax = _getTaxAmount();
  //   return gross - tax;
  // }

  Widget _getDetailSection({required Map shop, required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    var discountInput = TextInput(
      initialText: _discount,
      onText: (p0) {
        setState(() {
          _discount = p0;
          _errors = {..._errors, 'discount': ''};
        });
      },
      error: '${_errors['discount'] ?? ''}',
      label: 'Discount ( ${getShopCurrency(shop)} )',
    );
    var taxInput = TextInput(
      initialText: _tax,
      onText: (p0) {
        setState(() {
          _tax = p0;
          _errors = {..._errors, 'tax': ''};
        });
      },
      error: '${_errors['tax'] ?? ''}',
      label: 'Inclusive Tax %',
    );
    var customerInput = ChoicesInput(
      label: 'Customer',
      choice: _customer,
      error: '${_errors['customer'] ?? ''}',
      onChoice: (p0) {
        _updateState(() {
          _customer = p0 ?? {};
          _errors = {..._errors, 'customer': ''};
        });
      },
      onField: (p0) => p0?['displayName'] ?? '',
      getAddWidget: () => CreateCustomerContent(onDone: () {
        getCustomerFromCacheOrRemote(skipLocal: true).catchError((e) => []);
      }),
      onLoad: (bool skipLocal) async {
        return getCustomerFromCacheOrRemote(skipLocal: skipLocal).then((value) {
          return [
            ...itOrEmptyArray(value),
            {'id': 0, 'displayName': 'Walk In Customer'}
          ];
        });
      },
    );
    var grossAmount = TextInput(
      onText: (p0) => null,
      controller:
          TextEditingController(text: '${formatNumber(_getSaleAmount())}'),
      label: 'Total amount ( ${getShopCurrency(shop)} )',
      readOnly: true,
    );
    var taxValueInput = TextInput(
      onText: (p0) => null,
      controller:
          TextEditingController(text: '${formatNumber(_getTaxAmount())}'),
      label: 'Tax value ( ${getShopCurrency(shop)} )',
      readOnly: true,
    );
    var paymentMethodChoiceInput = ChoicesInput(
      label: 'Payment method',
      choice: _paymentMethod,
      error: '${_errors['payment_method'] ?? ''}',
      onChoice: (p0) {
        _updateState(() {
          _paymentMethod = p0 ?? {};
          _errors = {..._errors, 'payment_method': ''};
        });
      },
      onField: (p0) => p0?['name'] ?? '',
      onLoad: (bool skipLocal) async {
        return [
          {"name": "Invoice / Debt", "value": "invoice"},
          {"name": "M-Pesa", "value": "m_pesa"},
          {"name": "Tigopesa", "value": "tigopesa"},
          {"name": "Airtel Money", "value": "airtel_money"},
          {"name": "Halopesa", "value": "halopesa"},
          {"name": "Cash", "value": "cash"},
          {"name": "Bank", "value": "bank"},
          {"name": "Crypto", "value": "crypto"},
        ];
      },
    );
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              customerInput,
              const WhiteSpacer(width: 16),
              discountInput,
              const WhiteSpacer(width: 16),
              taxInput,
              const WhiteSpacer(width: 16),
              paymentMethodChoiceInput,
              const WhiteSpacer(width: 16),
              taxValueInput,
              const WhiteSpacer(width: 16),
              grossAmount,
            ])
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Row(
                    children: [
                      Expanded(child: customerInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: discountInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: taxInput),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: paymentMethodChoiceInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: taxValueInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: grossAmount),
                    ],
                  )
                ]),
    );
  }

  Widget _getHeaderSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var manageSaleTitle = const BodyLarge(text: 'Complete sale');
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [manageSaleTitle],
            )
          : Row(
              children: [
                manageSaleTitle,
                const Expanded(child: SizedBox()),
                // createdTitle
              ],
            ),
    );
  }

  Widget _getFooterSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var buttons = CancelProcessButtonsRow(
      cancelText: _confirmingSale ? null : "Cancel",
      proceedText: _confirmingSale ? 'Confirming...' : 'Confirm',
      onCancel: _confirmingSale ? null : () => Navigator.of(context).maybePop(),
      onProceed: _confirmingSale ? null : _onConfirmingSale,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      child: isSmallScreen
          ? buttons
          : Row(children: [
              Expanded(flex: 3, child: Container()),
              Expanded(flex: 1, child: buttons)
            ]),
    );
  }

  Widget _getItemsHeader({required Map shop}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    return _sectionWrapper(
      child: isSmallScreen
          ? const TableLikeListRow([LabelSmall(text: 'ITEMS')])
          : TableLikeListRow([
              const LabelSmall(text: 'WASTE'),
              const LabelSmall(text: 'QUANTITY'),
              LabelSmall(text: 'COST ( ${getShopCurrency(shop)} )'),
              LabelSmall(text: 'AMOUNT ( ${getShopCurrency(shop)} )'),
            ]),
      top: 16,
    );
  }

  List<Widget> _getItemsBody({required Map shop}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    return widget.carts.map<Widget>((item) {
      return _sectionWrapper(
        radius: 8,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TableLikeListRow(
                    [
                      TableLikeListTextDataCell(
                        firstLetterUpperCase('${item.product['product']}'),
                        verticalPadding: 0,
                      ),
                      TableLikeListTextDataCell(
                        '@${getShopCurrency(shop)} ${formatNumber('${item.product['retailPrice']}')}',
                        textAlign: TextAlign.end,
                        verticalPadding: 0,
                      ),
                    ],
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  ),
                  TableLikeListRow([
                    TableLikeListTextDataCell(
                      'QTY: ${item.quantity}',
                      verticalPadding: 0,
                    ),
                    TableLikeListTextDataCell(
                      '${getShopCurrency(shop)} ${formatNumber('${item.product['amount']}')}',
                      textAlign: TextAlign.end,
                      verticalPadding: 0,
                    ),
                  ])
                ],
              )
            : TableLikeListRow([
                TableLikeListTextDataCell(
                    firstLetterUpperCase('${item.product['product']}')),
                TableLikeListTextDataCell('${item.quantity}'),
                TableLikeListTextDataCell(
                    formatNumber('${item.product['retailPrice']}')),
                TableLikeListTextDataCell(formatNumber(
                    '${doubleOrZero('${item.quantity}') * doubleOrZero('${item.product['retailPrice']}')}')),
              ]),
        top: 8,
      );
    }).toList();
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _validateForm() {
    _updateState(() {
      _errors = {};
    });
    var hasError = true;
    if (_customer['id'] == null) {
      _errors['customer'] = 'Customer required';
      hasError = false;
    }
    if (_paymentMethod['value'] == null) {
      _errors['payment_method'] = 'Payment method required';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }

  _onConfirmingSale() {
    var valid = _validateForm();
    if (valid) {
      _updateState(() {
        _confirmingSale = true;
      });
      Future.delayed(Duration.zero).then((_) {
        if (_paymentMethod['value'] == 'invoice') {
          return onSubmitInvoice(
            carts: widget.carts,
            discount: doubleOrZero(_discount),
            customer: _customer,
            taxPercentage: doubleOrZero(_tax),
            cartId: _batchId,
          );
        } else {
          return onSubmitCashSale(
            carts: widget.carts,
            discount: doubleOrZero(_discount),
            customer: _customer,
            taxPercentage: doubleOrZero(_tax),
            cartId: _batchId,
          );
        }
      }).then((value) {
        _updateState(() {
          _confirmingSale = false;
        });
        var message =
            'The sale of ${_shop['settings']?['currency'] ?? ''} ${formatNumber(_getSaleAmount())} saved successful.\n'
            'You can print it or close to register another sale';
        showTransactionCompleteDialog(
          context,
          message,
          canDismiss: false,
          onPrint: () {
            _printSaleItems().catchError((e) {
              if (kDebugMode) {
                print(e);
              }
            });
          },
        ).whenComplete(() {
          widget.onDone(value);
        });
      }).catchError((error) {
        showTransactionCompleteDialog(context, error, title: 'Error',canDismiss: true);
        _updateState(() {
          _confirmingSale = false;
        });
      }).whenComplete(() {
        _updateState(() {
          _confirmingSale = false;
        });
      });
    }
  }

  Future _printSaleItems() async {
    var items = cartItems(widget.carts, _discount, _customer);
    var data = await cartItemsToPrinterData(
        items, _customer, (cart) => cart['stock']['retailPrice']);
    var hasDirectPrintPos = await hasDirectPosPrinterAPI();
    if (hasDirectPrintPos == true) {
      await directPosPrintAPI(data, '');
    } else {
      await posPrint(data: data, force: true);
    }
  }

  _getTaxAmount() {
    var totalAmount = _getSaleAmount();
    var tax = doubleOrZero(_tax);
    return totalAmount * (tax / 100);
  }
}
