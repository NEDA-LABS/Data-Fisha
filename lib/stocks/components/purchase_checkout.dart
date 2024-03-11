import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_user.dart';
import 'package:smartstock/core/services/cart.dart';
import 'package:smartstock/core/services/security.dart';
import 'package:smartstock/sales/models/cart.model.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/purchase.dart';
import 'package:smartstock/stocks/services/supplier.dart';
import 'package:uuid/uuid.dart';

_fn(dynamic d) => null;

class PurchaseCheckout extends StatefulWidget {
  final List<CartModel> carts;
  final Function(dynamic data) onDone;

  const PurchaseCheckout({
    required this.carts,
    this.onDone = _fn,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PurchaseCheckout> {
  final String _batchId = generateUUID();
  bool verifying = false;
  List<FileData?> _fileData = [];
  bool _confirmingPurchase = false;
  Map _shop = {};
  Map _vendor = {};
  Map _errors = {};
  bool _isInvoice = false;
  // String _reference = '';
  String _purchaseDate = '';
  String _purchaseDue = '';

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
        canPop: !_confirmingPurchase,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getHeaderSection(top: 16),
            // _getActionsSection(top: 16),
            const WhiteSpacer(height: 8),
            const HorizontalLine(),
            Expanded(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  // SliverToBoxAdapter(child: _getHeaderSection(top: 24)),
                  // SliverToBoxAdapter(child: _getActionsSection(top: 16)),
                  SliverToBoxAdapter(
                      child: _getDetailSection(shop: _shop, top: 8)),
                  SliverToBoxAdapter(child: _getFilesSection()),
                  // SliverToBoxAdapter(child: _getPaymentHeader(shop: _shop)),
                  // SliverList.list(children: _getPaymentBody(shop: _shop)),
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
    // var referenceInput = TextInput(
    //   onText: (p0) {
    //     setState(() {
    //       _reference = p0;
    //       _errors = {..._errors, 'reference': ''};
    //     });
    //   },
    //   error: '${_errors['reference'] ?? ''}',
    //   label: 'Reference',
    // );
    var dateInput = DateInput(
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 360)),
      onText: (p0) {
        setState(() {
          _purchaseDate = p0;
          _errors = {..._errors, 'date': ''};
        });
      },
      error: '${_errors['date'] ?? ''}',
      label: 'Date',
    );
    var dueDateInput = DateInput(
      initialDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 360)),
      firstDate: DateTime.now(),
      onText: (p0) {
        setState(() {
          _purchaseDue = p0;
          _errors = {..._errors, 'due': ''};
        });
      },
      error: '${_errors['due'] ?? ''}',
      label: 'Due date',
    );
    var supplierInput = ChoicesInput(
      label: 'Picker',
      choice: _vendor,
      error: '${_errors['vendor'] ?? ''}',
      onChoice: (p0) {
        _updateState(() {
          _vendor = p0 ?? {};
          _errors = {..._errors, 'vendor': ''};
        });
      },
      onField: (p0) => p0?['name'] ?? '',
      getAddWidget: () => CreateSupplierContent(onDone: () {
        getSupplierFromCacheOrRemote(true).catchError((e)=>[]);
      }),
      onLoad: (bool skipLocal) async {
        return getSupplierFromCacheOrRemote(skipLocal);
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
              // referenceInput,
              // const WhiteSpacer(width: 16),
              supplierInput,
              const WhiteSpacer(width: 16),
              amountInput,
              const WhiteSpacer(width: 16),
              dateInput,
              const WhiteSpacer(width: 16),
              _isInvoice ? dueDateInput : Container(),
            ])
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: supplierInput),
                      // const WhiteSpacer(width: 8),
                      // Expanded(child: referenceInput),
                      const WhiteSpacer(width: 8),
                      Expanded(child: amountInput),
                    ],
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 1, child: dateInput),
                      const WhiteSpacer(width: 8),
                      Expanded(
                          flex: 1,
                          child: _isInvoice ? dueDateInput : const SizedBox()),
                    ],
                  )
                ]),
    );
  }

  _getActionsSection({required double top}) {
    return _sectionWrapper(
      top: top,
      child: Wrap(
        children: [
          MenuContextAction(
            title: _isInvoice ? 'Mark as cash' : 'Mark as invoice',
            onPressed: _isInvoice ? _markAsNotInvoice : _markAsInvoice,
            textColor: _isInvoice ? Theme.of(context).colorScheme.error : null,
            color: _isInvoice ? Theme.of(context).colorScheme.error : null,
          ),
        ],
      ),
    );
  }

  _markAsNotInvoice() {
    _updateState(() {
      _isInvoice = false;
    });
  }

  _markAsInvoice() {
    _updateState(() {
      _isInvoice = true;
    });
  }

  _getHeaderSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    // var getPurchaseId = propertyOr('id', (p0) => '');
    // var getPurchaseDate = compose([
    //   DateFormat('yyyy-MM-dd HH:mm').format,
    //   DateTime.parse,
    //   propertyOr('createdAt', (p0) => DateTime.now().toIso8601String())
    // ]);
    var managePurchaseTitle = const BodyLarge(text: 'Complete collect order');
    // var createdTitle = BodyLarge(text: 'Created: ${getPurchaseDate(_item)}');
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
      cancelText: _confirmingPurchase ? null : "Cancel",
      proceedText: _confirmingPurchase ? 'Confirming...' : 'Confirm',
      onCancel:
          _confirmingPurchase ? null : () => Navigator.of(context).maybePop(),
      onProceed: _confirmingPurchase ? null : _onConfirmingPurchase,
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

  Widget _getFilesSection() {
    return _sectionWrapper(
      top: 16,
      child: FileSelect(
        files: _fileData,
        onFiles: (files) {
          _fileData = files;
        },
        // builder: _getFileSelectBuilder,
      ),
    );
  }

  _validateForm() {
    _updateState(() {
      _errors = {};
    });
    var hasError = true;
    if (_vendor['id'] == null) {
      _errors['vendor'] = 'Picker required';
      hasError = false;
    }
    // if (_reference == '') {
    //   _errors['reference'] = 'Reference required';
    //   hasError = false;
    // }
    if (_purchaseDate == '') {
      _errors['date'] = 'Date required';
      hasError = false;
    }
    if (_purchaseDue == '' && _isInvoice) {
      _errors['due'] = 'Purchase due date required';
      hasError = false;
    }
    // var purchasePrice = doubleOrZero('${_states['purchase']}');
    // var sellPrice = doubleOrZero('${_states['retailPrice']}');

    // if (_retailPrice == 0 || _retailPrice <= _purchase) {
    //   _errors['retailPrice'] =
    //   'Sell price required, must be greater than zero and purchase price';
    //   hasError = false;
    // }
    // if (_canExpire == true && _expire == '') {
    //   _errors['expire'] = 'Expire date required';
    //   hasError = false;
    // }
    _updateState(() {});
    return hasError;
  }

  Future<Map> _carts2Purchase(List<String> files) async {
    var currentUser = await getLocalCurrentUser();
    var t =
        '${cartTotalAmount(widget.carts, (product) => doubleOrZero(product['purchase']))}';
    var totalAmount = doubleOrZero(t);
    // var due = pDetail['due'];
    // var type = pDetail['type'];
    // var refNumber = pDetail['reference'];
    // String? date = pDetail['date'];
    // String? dueDate = date;
    // if (type == 'invoice' && ((due is String && due.isEmpty) || due == null)) {
    //   dueDate = toSqlDate(DateTime.now().add(const Duration(days: 30)));
    // }
    if (!_isInvoice) {
      _purchaseDue = _purchaseDate;
    }
    return {
      "date": _purchaseDate,
      "due": _purchaseDate,
      "refNumber": _vendor['name'] ?? 'general',
      "batchId": _batchId,
      "amount": totalAmount,
      "supplier": {"name": _vendor['name'] ?? 'general'},
      "user": {"username": currentUser['username'] ?? ''},
      "type": 'cash',
      "images": files,
      "items": widget.carts.map((e) {
        return {
          "wholesalePrice": doubleOrZero(e.product['purchase']),
          "retailPrice": doubleOrZero(e.product['purchase']),
          "expire": '',
          "product": {
            "id": e.product['id'],
            "__type": e.product['__type'] ?? 'old',
            "product": e.product['product'],
            "stockable": false,
            "purchase": doubleOrZero(e.product['purchase']),
            "supplier": _vendor['name'] ?? 'general'
          },
          "amount": doubleOrZero('${e.product['purchase']}') *
              doubleOrZero(e.quantity),
          "purchase": e.product['purchase'],
          "quantity": e.quantity
        };
      }).toList()
    };
  }

  void _onConfirmingPurchase() {
    var valid = _validateForm();
    if (valid) {
      _updateState(() {
        _confirmingPurchase = true;
      });
      uploadFileToWeb3(_fileData).then((value) {
        var files =
            itOrEmptyArray(value).map((e) => '${e['link'] ?? ''}').toList();
        return _carts2Purchase(files);
      }).then((value) {
        return productsPurchaseCreate(purchase: value);
      }).then((value) {
        _updateState(() {
          _confirmingPurchase = false;
        });
        showTransactionCompleteDialog(context, 'Waste collected successful',canDismiss: false, onClose: (){
          widget.onDone(value);
        });
      }).catchError((error) {
        showTransactionCompleteDialog(context, error, title: 'Error',canDismiss: false);
        _updateState(() {
          _confirmingPurchase = false;
        });
      }).whenComplete(() {
        _updateState(() {
          _confirmingPurchase = false;
        });
      });
    }
  }
}
