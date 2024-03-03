import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/api_suppliers.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class SuppliersPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const SuppliersPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'PickersPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SuppliersPage> {
  bool _isLoading = false;
  String _query = '';
  List _suppliers = [];

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Pickers",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onBack: widget.onBackPage,
      onSearch: (p0) {
        if (p0.startsWith('-1:') == false) {
          setState(() {
            _query = p0;
            getSupplierFromCacheOrRemote(false).then((value) {
              _suppliers = value
                  .where((element) => '${element['name']}'
                      .toLowerCase()
                      .contains(_query.toLowerCase()))
                  .toList();
            }).whenComplete(() => setState(() {}));
          });
        }
      },
      searchHint: 'Search...',
      context: context,
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(name: 'Create', pressed: _createSupplier),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchSuppliers();
        },
      ),
    ];
  }

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  _fetchSuppliers() {
    setState(() {
      _isLoading = true;
    });
    getSupplierFromCacheOrRemote(true).then((value) {
      _suppliers = value;
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _fetchSuppliers();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/stock/',
        sliverAppBar: _appBar(context),
        backgroundColor: Theme.of(context).colorScheme.surface,
        staticChildren: [
          getTableContextMenu(_contextItems(context)),
          _loading(_isLoading),
          // getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        totalDynamicChildren: _suppliers.length,
        dynamicChildBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                onTap: () => _onManageCategory(index),
                contentPadding: EdgeInsets.zero,
                title: BodyLarge(
                    text: firstLetterUpperCase('${_suppliers[index]['name']}')),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LabelLarge(
                        text: firstLetterUpperCase(
                            '${_suppliers[index]['number']}')),
                    LabelLarge(
                        text: firstLetterUpperCase(
                            '${_suppliers[index]['address']}')),
                    // LabelLarge(text: firstLetterUpperCase('${_suppliers[index]['email']}')),
                  ],
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      '${_suppliers[index]['image']}',
                      errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LabelLarge(
                      text: 'Manage',
                      color: Theme.of(context).primaryColor,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const HorizontalLine(),
              const SizedBox(height: 16),
            ],
          );
        },
        fab: FloatingActionButton(
          onPressed: () => _showMobileContextMenu(context),
          child: const Icon(Icons.unfold_more_outlined),
        ),
      );

  void _showMobileContextMenu(context) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.add),
                title: const BodyLarge(text: 'Create'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _createSupplier());
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _fetchSuppliers();
                },
              ),
            ],
          ),
        ),
        context);
  }

  _createSupplier() {
    showDialogOrFullScreenModal(CreateSupplierContent(
      onDone: () {
        _fetchSuppliers();
      },
    ), context);
  }

  void _onManageCategory(index) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          constraints: getIsSmallScreen(context)
              ? null
              : const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BodyLarge(
                  text:
                      'Manage picker " ${_suppliers[index]?['name'] ?? ''} "'),
              const WhiteSpacer(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    _onEditPicker(index);
                  });
                },
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const BodyLarge(text: 'Edit picker'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    _onDelete(index);
                  });
                },
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const BodyLarge(text: 'Delete picker'),
              )
            ],
          ),
        ),
        context);
  }

  _onDelete(index) {
    showDialogDelete(
      onDone: (p0) {
        Navigator.of(context).maybePop();
      },
      context: context,
      name: firstLetterUpperCase('${_suppliers[index]['name']}'),
      onDelete: () {
        return _deletePicker('${_suppliers[index]['id']}');
      },
    );
  }

  Future _deletePicker(id) async {
    var shop = await getActiveShop();
    var deletePicker = prepareDeleteSupplierAPI(id);
    await deletePicker(shop);
    _fetchSuppliers();
  }

  void _onEditPicker(index) {
    showDialogOrFullScreenModal(
      CreateSupplierContent(
          supplier: _suppliers[index], onDone: _fetchSuppliers),
      context,
    );
  }
}
