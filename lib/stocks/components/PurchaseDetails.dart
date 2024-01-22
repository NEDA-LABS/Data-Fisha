import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelSmall.dart';
import 'package:smartstock/core/components/MenuContextAction.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/with_active_shop.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/stocks/services/purchase.dart';

_fn(Map d) => null;

class PurchaseDetails extends StatefulWidget {
  final dynamic item;
  final Function(Map data) onDoneDelete;
  final Function(Map data) onDoneVerify;
  final Function(Map data) onDoneUpdate;

  const PurchaseDetails({
    required this.item,
    this.onDoneDelete = _fn,
    this.onDoneUpdate = _fn,
    this.onDoneVerify = _fn,
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

  @override
  void initState() {
    _item = {...widget.item};
    _fileData = _getInitialFileData(_item);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WithActiveShop(
      onChild: (shop) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getHeaderSection(top: 24),
            _getActionsSection(top: 16),
            const WhiteSpacer(height: 8),
            const HorizontalLine(),
            Expanded(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  // SliverToBoxAdapter(child: _getHeaderSection(top: 24)),
                  // SliverToBoxAdapter(child: _getActionsSection(top: 16)),
                  SliverToBoxAdapter(
                      child: _getDetailSection(shop: shop, top: 8)),
                  SliverToBoxAdapter(child: _getFilesSection()),
                  SliverToBoxAdapter(child: _getPaymentHeader(shop: shop)),
                  SliverList.list(children: _getPaymentBody()),
                  SliverToBoxAdapter(child: _getItemsHeader(shop: shop)),
                  SliverList.list(children: _getItemsBody()),
                  // SliverToBoxAdapter(child: _getFooterSection(top: 16))
                ],
              ),
            ),
            const HorizontalLine(),
            _getFooterSection(top: 16)
          ],
        );
      },
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

  List _getPayments(item) {
    return itOrEmptyArray(item);
    // if (item is List<Map<String, dynamic>>) {
    //   return item;
    //   // return item.map((e) => ({"date": e, "amount": item[e]})).toList();
    // }
    // return [];
  }

  Widget _getFileSelectBuilder(isEmpty, onPress) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: InkWell(
        onTap: onPress,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
                // height: 10,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 1,
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BodyLarge(text: "Click to select image"),
                    WhiteSpacer(height: 6),
                    LabelLarge(
                      text: "Recommended ration 1:1",
                      color: Colors.grey,
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget _sectionWrapper({required Widget child, required double top}) {
    var hPadding = EdgeInsets.only(left: 24, right: 24, top: top);
    return Container(padding: hPadding, child: child);
  }

  Widget _getDetailSection({required Map shop, required double top}) {
    var getPurchaseRef = propertyOr('refNumber', (p0) => '');
    var getPurchaseSupplier = propertyOr('supplier', (p0) => '');
    var getPurchaseAmount = propertyOr('amount', (p0) => '');
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    return _sectionWrapper(
      top: top,
      child: Row(
        children: [
          Expanded(
            child: TextInput(
              onText: (p0) => null,
              initialText: '${getPurchaseRef(_item)}',
              label: 'Reference',
              readOnly: true,
            ),
          ),
          const WhiteSpacer(width: 16),
          Expanded(
            child: TextInput(
              onText: (p0) => null,
              initialText: '${getPurchaseSupplier(_item)}',
              label: 'Supplier',
              readOnly: true,
            ),
          ),
          const WhiteSpacer(width: 16),
          Expanded(
            child: TextInput(
              onText: (p0) => null,
              initialText: '${formatNumber(getPurchaseAmount(_item))}',
              label: 'Amount ( ${getShopCurrency(shop)} )',
              readOnly: true,
            ),
          ),
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
          isInvoice(_item) == true
              ? MenuContextAction(
                  title: 'Make payment', onPressed: _makePayment)
              : Container(),
          MenuContextAction(
            title: verifying
                ? 'Processing...'
                : verified
                    ? 'Mark not verified'
                    : 'Mark as verified',
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
    var getPurchaseId = propertyOr('id', (p0) => '');
    var getPurchaseDate = compose([
      DateFormat('yyyy-MM-dd HH:mm').format,
      DateTime.parse,
      propertyOr('createdAt', (p0) => DateTime.now().toIso8601String())
    ]);
    return _sectionWrapper(
      top: top,
      child: Row(
        children: [
          BodyLarge(text: 'Manage purchase #${getPurchaseId(_item)}'),
          const Expanded(child: SizedBox()),
          BodyLarge(text: 'Created: ${getPurchaseDate(_item)}')
        ],
      ),
    );
  }

  _getFooterSection({required double top}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Container()),
          Expanded(
            flex: 1,
            child: CancelProcessButtonsRow(
              cancelText: _updatingAttachment ? null : "Close",
              proceedText: _filesTouched
                  ? _updatingAttachment
                      ? 'Saving...'
                      : 'Update'
                  : null,
              onCancel: _updatingAttachment
                  ? null
                  : () => Navigator.of(context).maybePop(),
              onProceed: _updatingAttachment ? null : _updateAttachment,
            ),
          )
        ],
      ),
    );
  }

  _getPaymentHeader({required Map shop}) {
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    var getPayments = propertyOrNull('payments');
    return _getPayments(getPayments(_item)).isNotEmpty
        ? _sectionWrapper(
            child: TableLikeListRow([
              const LabelSmall(text: 'DATE'),
              LabelSmall(text: 'AMOUNT ( ${getShopCurrency(shop)} )'),
              const LabelSmall(text: 'MODE'),
              const LabelSmall(text: 'REFERENCE'),
            ]),
            top: 16,
          )
        : Container();
  }

  List<Widget> _getPaymentBody() {
    var getPayments = propertyOrNull('payments');
    return _getPayments(getPayments(_item)).map<Widget>((item) {
      return _sectionWrapper(
          child: TableLikeListRow([
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
          top: 0);
    }).toList();
  }

  _getItemsHeader({required Map shop}) {
    var getShopCurrency = compose(
        [propertyOr('currency', (p0) => 'TZS'), propertyOrNull('settings')]);
    return _sectionWrapper(
      child: TableLikeListRow([
        const LabelSmall(text: 'PRODUCT'),
        const LabelSmall(text: 'QUANTITY'),
        LabelSmall(text: 'COST ( ${getShopCurrency(shop)} )'),
        LabelSmall(text: 'AMOUNT ( ${getShopCurrency(shop)} )'),
      ]),
      top: 16,
    );
  }

  List<Widget> _getItemsBody() {
    var getItems = propertyOrNull('items');
    return itOrEmptyArray(getItems(_item)).map<Widget>((item) {
      return _sectionWrapper(
        child: TableLikeListRow([
          BodyLarge(text: '${item['product']}'),
          Text('${item['quantity']}'),
          Text(formatNumber('${item['purchase']}')),
          Text(formatNumber('${item['amount']}')),
        ]),
        top: 0,
      );
    }).toList();
  }

  void _makePayment() {
    // Navigator.of(context).maybePop().whenComplete(() {
    //   showDialog(
    //       context: context,
    //       builder: (_) => Dialog(
    //           child:
    //               AddPurchasePaymentContent(_item['id'])));
    // });
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
      showInfoDialog(context, error, title: 'Error');
    }).whenComplete(() {
      _updateState(() {
        verifying = false;
      });
    });
  }

  void _markVerified() {
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
      showInfoDialog(context, error, title: 'Error');
    }).whenComplete(() {
      _updateState(() {
        verifying = false;
      });
    });
  }

  void _handleDelete() {}

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
      showInfoDialog(context, 'Attachments updated');
      _filesTouched = false;
      widget.onDoneUpdate({'images': _item['images']});
    }).catchError((error) {
      _item['images'] = [];
      showInfoDialog(context, error, title: 'Error');
    }).whenComplete(() {
      _updateState(() {
        _updatingAttachment = false;
      });
    });
  }
}
