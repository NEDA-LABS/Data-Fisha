import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/services/transfer.dart';

_fn(dynamic d) => null;

class TransferCheckout extends StatefulWidget {
  final String batchId;
  final List<CartModel> carts;
  final String type;
  final Function(dynamic data) onDone;

  const TransferCheckout({
    required this.carts,
    required this.batchId,
    this.onDone = _fn,
    super.key,
    required this.type,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TransferCheckout> {
  final String _batchId = generateUUID();
  bool _confirming = false;
  Map _shop = {};
  Map _otherShop = {};
  Map _errors = {};
  String _transferDate = '';

  @override
  void initState() {
    getActiveShop().then((value) {
      _updateState(() {
        _shop = value;
      });
    }).catchError((e) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !_confirming,
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
                  SliverToBoxAdapter(child: _getItemsHeader(shop: _shop)),
                  SliverList.list(children: _getItemsBody(shop: _shop)),
                  const SliverToBoxAdapter(child: WhiteSpacer(height: 24))
                ],
              ),
            ),
            const HorizontalLine(),
            _getFooterSection(top: 16)
          ],
        ));
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
        // color: color,
        border: color != null ? Border.all(color: color) : null,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: child,
    );
  }

  _getPurchaseAmount() {
    return widget.carts.fold(
        0.0, (a, b) => a + doubleOrZero(b.product['purchase']) * b.quantity);
  }

  Widget _getDetailSection({required Map shop, required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    var primaryShopInput = TextInput(
      // initialText: '${shop['businessName']}',
      controller: TextEditingController(text: '${shop['businessName'] ?? ''}'),
      onText: (p0) {
        // setState(() {
        //   _reference = p0;
        //   _errors = {..._errors, 'reference': ''};
        // });
      },
      readOnly: true,
      label: widget.type == 'send' ? 'From shop' : 'To shop',
    );
    var dateInput = DateInput(
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      onText: (p0) {
        setState(() {
          _transferDate = p0;
          _errors = {..._errors, 'date': ''};
        });
      },
      error: '${_errors['date'] ?? ''}',
      label: 'Date',
    );
    var shopsInput = ChoicesInput(
      label: widget.type == 'send' ? 'To shop' : 'From shop',
      choice: _otherShop,
      error: '${_errors['other_shop'] ?? ''}',
      onChoice: (p0) {
        _updateState(() {
          _otherShop = p0 ?? {};
          _errors = {..._errors, 'other_shop': ''};
        });
      },
      onField: (p0) => p0?['name'] ?? '',
      onLoad: (bool skipLocal) async {
        return getOtherShopsNames(skipLocal: false);
      },
    );
    var amountInput = TextInput(
      onText: (p0) => null,
      initialText: '${formatNumber(_getPurchaseAmount())}',
      label: 'Amount ( ${getShopCurrency(shop)} )',
      readOnly: true,
    );
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(mainAxisSize: MainAxisSize.min, children: [
              shopsInput,
              const WhiteSpacer(width: 16),
              primaryShopInput,
              const WhiteSpacer(width: 16),
              amountInput,
              const WhiteSpacer(width: 16),
              dateInput,
            ])
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Row(
                    children: [
                      Expanded(child: shopsInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: primaryShopInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: amountInput),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(flex: 1, child: dateInput),
                      const WhiteSpacer(width: 8),
                      const Expanded(flex: 1, child: SizedBox()),
                    ],
                  )
                ]),
    );
  }

  _getHeaderSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var managePurchaseTitle =
        BodyLarge(text: 'Complete ${widget.type} transfer order');
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [managePurchaseTitle],
            )
          : Row(
              children: [
                managePurchaseTitle,
                const Expanded(child: SizedBox()),
                // createdTitle
              ],
            ),
    );
  }

  _getFooterSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var buttons = CancelProcessButtonsRow(
      cancelText: _confirming ? null : "Cancel",
      proceedText: _confirming ? 'Confirming...' : 'Confirm',
      onCancel: _confirming ? null : () => Navigator.of(context).maybePop(),
      onProceed: _confirming ? null : _onConfirmingPurchase,
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

  _getItemsHeader({required Map shop}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    return _sectionWrapper(
      child: isSmallScreen
          ? const TableLikeListRow([LabelSmall(text: 'ITEMS')])
          : TableLikeListRow([
              const LabelSmall(text: 'PRODUCT'),
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
    // var getItems = propertyOrNull('items');
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
                        '@${getShopCurrency(shop)} ${formatNumber('${item.product['purchase']}')}',
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
                    formatNumber('${item.product['purchase']}')),
                TableLikeListTextDataCell(formatNumber(
                    '${doubleOrZero('${item.quantity}') * doubleOrZero('${item.product['purchase']}')}')),
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
    if (_otherShop['name'] == null) {
      _errors['other_shop'] = 'Shop required';
      hasError = false;
    }
    if (_transferDate == '') {
      _errors['date'] = 'Transfer date required';
      hasError = false;
    }
    _updateState(() {});
    return hasError;
  }

  Future<Map> _carts2Transfer() async {
    var currentUser = await getLocalCurrentUser();
    var t =
        '${cartTotalAmount(widget.carts, (product) => product['purchase'])}';
    var totalAmount = doubleOrZero(t);
    return {
      "date": DateTime.now().toIso8601String(),
      "batchId": _batchId,
      "transferred_by": {"username": currentUser['username']},
      "amount": totalAmount,
      "other_shop": '${_otherShop['businessName'] ?? ''}',
      "items": widget.carts.map((e) {
        return {
          "from_id": e.product['id'],
          "purchase": doubleOrZero(e.product['purchase']),
          "product": e.product['product'],
          "quantity": doubleOrZero(e.quantity),
        };
      }).toList()
    };
  }

  void _onConfirmingPurchase() {
    var valid = _validateForm();
    if (valid) {
      _updateState(() {
        _confirming = true;
      });
      _carts2Transfer().then((value) {
        if (widget.type == 'send') {
          return transferSend(value);
        }
        if (widget.type == 'receive') {
          return transferReceive(value);
        }
        throw Exception('Invalid transfer action');
      }).then((value) {
        _updateState(() {
          _confirming = false;
        });
        showTransactionCompleteDialog(context, 'Transfer submitted',onClose: (){

        }).whenComplete(() {
          widget.onDone(value);
        });
      }).catchError((error) {
        showTransactionCompleteDialog(context, error, title: 'Error',onClose: (){

        });
        _updateState(() {
          _confirming = false;
        });
      }).whenComplete(() {
        _updateState(() {
          _confirming = false;
        });
      });
    }
  }
}
