import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/DialogContentWrapper.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/stocks/components/add_purchase_payment.dart';
import 'package:smartstock/stocks/services/purchase.dart';

_fn(Map d) => null;

class PurchaseDetails extends StatefulWidget {
  final dynamic item;
  final Function(Map data) onDoneDelete;
  final Function(Map data) onDoneVerify;
  final Function(Map data) onDoneUpdate;
  final Function(Map data) onDonePayment;

  const PurchaseDetails({
    required this.item,
    this.onDoneDelete = _fn,
    this.onDoneUpdate = _fn,
    this.onDoneVerify = _fn,
    this.onDonePayment = _fn,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PurchaseDetails> {
  Map _item = {};
  bool verifying = false;
  List<FileData?> _fileData = [];
  bool _filesTouched = false;
  bool _updatingAttachment = false;
  Map _shop = {};

  @override
  void initState() {
    getActiveShop().then((value) {
      _shop = value;
    }).catchError((e) {});
    _item = {...widget.item};
    _fileData = _getInitialFileData(_item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _getHeaderSection(top: 16),
        _getActionsSection(top: 16),
        const WhiteSpacer(height: 8),
        const HorizontalLine(),
        Expanded(
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: [
              // SliverToBoxAdapter(child: _getHeaderSection(top: 24)),
              // SliverToBoxAdapter(child: _getActionsSection(top: 16)),
              SliverToBoxAdapter(child: _getDetailSection(shop: _shop, top: 8)),
              SliverToBoxAdapter(child: _getFilesSection()),
              SliverToBoxAdapter(child: _getPaymentHeader(shop: _shop)),
              SliverList.list(children: _getPaymentBody(shop: _shop)),
              SliverToBoxAdapter(child: _getItemsHeader(shop: _shop)),
              SliverList.list(children: _getItemsBody(shop: _shop)),
              const SliverToBoxAdapter(child: WhiteSpacer(height: 24))
            ],
          ),
        ),
        const HorizontalLine(),
        _getFooterSection(top: 16)
      ],
    );
  }

  List<FileData?> _getInitialFileData(Map purchase) {
    return itOrEmptyArray(purchase['images']).map((x) {
      String name = x.split('/').last;
      String ext = name.split('.').last;
      return FileData(
          stream: null, extension: ext, size: -1, name: name, path: x);
    }).toList();
  }

  // Widget _getFileSelectBuilder(isEmpty, onPress) {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 16),
  //     child: InkWell(
  //       onTap: onPress,
  //       child: LayoutBuilder(
  //         builder: (context, constraints) {
  //           return Container(
  //               // height: 10,
  //               alignment: Alignment.center,
  //               padding: const EdgeInsets.all(8),
  //               width: constraints.maxWidth,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(
  //                   color: Theme.of(context).colorScheme.background,
  //                   width: 1,
  //                 ),
  //               ),
  //               child: const Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   BodyLarge(text: "Click to select image"),
  //                   WhiteSpacer(height: 6),
  //                   LabelLarge(
  //                     text: "Recommended ration 1:1",
  //                     color: Colors.grey,
  //                   ),
  //                 ],
  //               ));
  //         },
  //       ),
  //     ),
  //   );
  // }

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

  Widget _getDetailSection({required Map shop, required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getPurchaseRef = propertyOr('refNumber', (p0) => '');
    var getPurchaseSupplier = propertyOr('supplier', (p0) => '');
    var getPurchaseAmount = propertyOr('amount', (p0) => '');
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    var referenceInput = TextInput(
      onText: (p0) => null,
      initialText: '${getPurchaseRef(_item)}',
      label: 'Reference',
      readOnly: true,
    );
    var supplierInput = TextInput(
      onText: (p0) => null,
      initialText: '${getPurchaseSupplier(_item)}',
      label: 'Supplier',
      readOnly: true,
    );
    var amountInput = TextInput(
      onText: (p0) => null,
      initialText: '${formatNumber(getPurchaseAmount(_item))}',
      label: 'Amount ( ${getShopCurrency(shop)} )',
      readOnly: true,
    );
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [referenceInput, supplierInput, amountInput],
            )
          : Row(
              children: [
                Expanded(child: referenceInput),
                const WhiteSpacer(width: 16),
                Expanded(child: supplierInput),
                const WhiteSpacer(width: 16),
                Expanded(child: amountInput),
              ],
            ),
    );
  }

  _getActionsSection({required double top}) {
    var isInvoice = compose([
      ifDoElse((x) => x == 'receipt', (_) => false, (_) => true),
      propertyOrNull('type')
    ]);
    var isVerified = compose([
      (x) => x == true,
      propertyOrNull('verified'),
      propertyOrNull('metadata')
    ]);
    bool verified = isVerified(_item) == true;
    return _sectionWrapper(
      top: top,
      child: Wrap(
        children: [
          isInvoice(_item) == true && !verified
              ? MenuContextAction(
                  title: 'Make payment', onPressed: _makePayment)
              : Container(),
          MenuContextAction(
            title: verifying
                ? 'Processing...'
                : verified
                    ? 'Mark as draft'
                    : 'Mark as reviewed',
            onPressed: verifying
                ? null
                : verified
                    ? _markNotVerified
                    : _markVerified,
            textColor: verified ? Theme.of(context).colorScheme.error : null,
            color: verified ? Theme.of(context).colorScheme.error : null,
          ),
          // MenuContextAction(title: 'Show payments', onPressed: () {}),
          verified
              ? Container()
              : MenuContextAction(
                  title: 'Delete',
                  onPressed: _handleDelete,
                  color: Theme.of(context).colorScheme.error,
                  textColor: Theme.of(context).colorScheme.error),
        ],
      ),
    );
  }

  _getHeaderSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getPurchaseId = propertyOr('id', (p0) => '');
    var getPurchaseDate = compose([
      DateFormat('yyyy-MM-dd HH:mm').format,
      DateTime.parse,
      propertyOr('createdAt', (p0) => DateTime.now().toIso8601String())
    ]);
    var managePurchaseTitle =
        BodyLarge(text: 'Manage purchase #${getPurchaseId(_item)}');
    var createdTitle = BodyLarge(text: 'Created: ${getPurchaseDate(_item)}');
    return _sectionWrapper(
      top: top,
      child: isSmallScreen
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [managePurchaseTitle, createdTitle],
            )
          : Row(
              children: [
                managePurchaseTitle,
                const Expanded(child: SizedBox()),
                createdTitle
              ],
            ),
    );
  }

  _getFooterSection({required double top}) {
    var isSmallScreen = getIsSmallScreen(context);
    var buttons = CancelProcessButtonsRow(
      cancelText: _updatingAttachment ? null : "Close",
      proceedText: _filesTouched
          ? _updatingAttachment
              ? 'Saving...'
              : 'Update'
          : null,
      onCancel:
          _updatingAttachment ? null : () => Navigator.of(context).maybePop(),
      onProceed: _updatingAttachment ? null : _updateAttachment,
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

  _getPaymentHeader({required Map shop}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    var getPayments = propertyOrNull('payments');
    return itOrEmptyArray(getPayments(_item)).isNotEmpty
        ? _sectionWrapper(
            child: isSmallScreen
                ? const TableLikeListRow([LabelSmall(text: 'PAYMENTS')])
                : TableLikeListRow([
                    const LabelSmall(text: 'DATE'),
                    LabelSmall(text: 'AMOUNT ( ${getShopCurrency(shop)} )'),
                    const LabelSmall(text: 'MODE'),
                    const LabelSmall(text: 'REFERENCE'),
                  ]),
            top: 16,
          )
        : Container();
  }

  List<Widget> _getPaymentBody({required Map shop}) {
    var isSmallScreen = getIsSmallScreen(context);
    var getShopCurrency = compose(
      [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')],
    );
    var getPayments = propertyOrNull('payments');
    return itOrEmptyArray(getPayments(_item)).map<Widget>((item) {
      return _sectionWrapper(
        radius: 8,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TableLikeListRow(
                    [
                      TableLikeListTextDataCell(
                        '${getShopCurrency(shop)} ${formatNumber('${item?['amount'] ?? ''}')}',
                        verticalPadding: 0,
                      ),
                      TableLikeListTextDataCell(
                        '${item?['reference'] ?? ''}',
                        verticalPadding: 0,
                        textAlign: TextAlign.end,
                      ),
                    ],
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  ),
                  TableLikeListRow([
                    TableLikeListTextDataCell(
                      '${item?['date'] ?? ''}',
                      verticalPadding: 0,
                    ),
                    TableLikeListTextDataCell(
                      '${item?['mode'] ?? ''}',
                      verticalPadding: 0,
                      textAlign: TextAlign.end,
                    ),
                  ]),
                ],
              )
            : TableLikeListRow([
                TableLikeListTextDataCell(
                  '${item?['date'] ?? ''}',
                  verticalPadding: 0,
                ),
                TableLikeListTextDataCell(
                  formatNumber('${item?['amount'] ?? ''}'),
                  verticalPadding: 0,
                ),
                TableLikeListTextDataCell(
                  '${item?['mode'] ?? ''}',
                  verticalPadding: 0,
                ),
                TableLikeListTextDataCell(
                  '${item?['reference'] ?? ''}',
                  verticalPadding: 0,
                ),
              ]),
        top: 8,
      );
    }).toList();
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
    var getItems = propertyOrNull('items');
    return itOrEmptyArray(getItems(_item)).map<Widget>((item) {
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
                        firstLetterUpperCase('${item['product']}'),
                        verticalPadding: 0,
                      ),
                      TableLikeListTextDataCell(
                        '@${getShopCurrency(shop)} ${formatNumber('${item['purchase']}')}',
                        textAlign: TextAlign.end,
                        verticalPadding: 0,
                      ),
                    ],
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  ),
                  TableLikeListRow([
                    TableLikeListTextDataCell(
                      'QTY: ${item['quantity']}',
                      verticalPadding: 0,
                    ),
                    TableLikeListTextDataCell(
                      '${getShopCurrency(shop)} ${formatNumber('${item['amount']}')}',
                      textAlign: TextAlign.end,
                      verticalPadding: 0,
                    ),
                  ])
                ],
              )
            : TableLikeListRow([
                TableLikeListTextDataCell(
                    firstLetterUpperCase('${item['product']}')),
                TableLikeListTextDataCell('${item['quantity']}'),
                TableLikeListTextDataCell(formatNumber('${item['purchase']}')),
                TableLikeListTextDataCell(formatNumber('${item['amount']}')),
              ]),
        top: 8,
      );
    }).toList();
  }

  void _makePayment() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          child: DialogContentWrapper(
              child: AddPurchasePaymentContent(
            purchase: _item,
            onDone: (payment) {
              _updateState(() {
                _item['payments'] = [
                  ...itOrEmptyArray(_item['payments']),
                  {'date': toSqlDate(DateTime.now()), ...payment}
                ];
              });
              widget.onDonePayment(payment);
            },
          )),
        );
      },
    );
  }

  void _markNotVerified() {
    _updateState(() {
      verifying = true;
    });
    productsPurchaseMetadataUpdate(
      id: _item['id'],
      metadata: {'verified': false},
    ).then((value) {
      _item['metadata'] = {..._item['metadata'] ?? {}, 'verified': false};
      widget.onDoneVerify({'verified': false});
    }).catchError((error) {
      showTransactionCompleteDialog(context, error, title: 'Error',onClose: (){

      });
    }).whenComplete(() {
      _updateState(() {
        verifying = false;
      });
    });
  }

  _getInvPayment(purchase) {
    if (purchase is Map) {
      var type = purchase['type'];
      if (type == 'invoice') {
        var payments = purchase['payments'];
        if (payments is List) {
          double a = payments.fold(0,
              (dynamic a, element) => a + doubleOrZero('${element['amount']}'));
          return a;
        }
      } else {
        return doubleOrZero(purchase['amount']);
      }
    }
    return 0;
  }

  void _markVerified() {
    bool isPaid = _getInvPayment(_item) >= doubleOrZero(_item['amount']);
    if (!isPaid) {
      showTransactionCompleteDialog(context,
          'Invoice is not paid yet, you can not mark it as reviewed. Finalize purchase invoice payments',onClose: (){

          });
      return;
    }
    _updateState(() {
      verifying = true;
    });
    productsPurchaseMetadataUpdate(
      id: _item['id'],
      metadata: {'verified': true},
    ).then((value) {
      _item['metadata'] = {..._item['metadata'] ?? {}, 'verified': true};
      widget.onDoneVerify({'verified': true});
    }).catchError((error) {
      showTransactionCompleteDialog(context, error, title: 'Error',onClose: (){

      });
    }).whenComplete(() {
      _updateState(() {
        verifying = false;
      });
    });
  }

  void _handleDelete() {
    showDialogDelete(
      onDone: (p0) {
        Navigator.of(context).maybePop().whenComplete(() {
          widget.onDoneDelete(widget.item);
        });
      },
      context: context,
      name: 'purchase #${widget.item['id']}'
          ' will revert all quantities of respective products if any and',
      onDelete: () async => productsPurchaseDelete(id: widget.item['id']),
    );
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Widget _getFilesSection() {
    var isVerified = compose([
      (x) => x == true,
      propertyOrNull('verified'),
      propertyOrNull('metadata')
    ]);
    bool verified = isVerified(_item) == true;
    return _sectionWrapper(
      top: 16,
      child: FileSelect(
        readOnly: verified,
        files: _fileData,
        onFiles: (files) {
          _fileData = files;
          _updateState(() {
            _filesTouched = true;
          });
        },
        // builder: _getFileSelectBuilder,
      ),
    );
  }

  void _updateAttachment() {
    _updateState(() {
      _updatingAttachment = true;
    });
    uploadFileToWeb3(_fileData).then((value) {
      // if (kDebugMode) {
      //   print(value);
      // }
      var files =
          itOrEmptyArray(value).map((e) => '${e['link'] ?? ''}').toList();
      _item['images'] = files;
      return productsPurchaseAttachmentsUpdate(id: _item['id'], files: files);
    }).then((value) {
      // if (kDebugMode) {
      //   print(value);
      // }
      showTransactionCompleteDialog(context, 'Attachments updated',onClose: (){

      });
      _filesTouched = false;
      widget.onDoneUpdate({'images': _item['images']});
    }).catchError((error) {
      _item['images'] = [];
      showTransactionCompleteDialog(context, error, title: 'Error',onClose: (){

      });
    }).whenComplete(() {
      _updateState(() {
        _updatingAttachment = false;
      });
    });
  }
}
