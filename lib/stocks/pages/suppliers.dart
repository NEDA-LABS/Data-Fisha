import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class SuppliersPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const SuppliersPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'VendorsPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SuppliersPage> {
  bool _isLoading = false;
  String _query = '';
  List _suppliers = [];

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Vendors",
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

  _tableHeader() => const TableLikeListRow([
        TableLikeListHeaderCell('Name'),
        TableLikeListHeaderCell('Mobile'),
        TableLikeListHeaderCell('Email'),
        TableLikeListHeaderCell('Address'),
      ]);

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
          getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        totalDynamicChildren: _suppliers.length,
        dynamicChildBuilder:
            getIsSmallScreen(context) ? _smallScreen : _largerScreen,
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
                leading: const Icon(Icons.add),
                title: const BodyLarge(text: 'Create supplier'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _createSupplier());
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload suppliers'),
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
    showDialogOrFullScreenModal(CreateSupplierContent(onDone: (){
      _fetchSuppliers();
    },), context);
  }

  Widget _largerScreen(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableLikeListRow([
          TableLikeListTextDataCell('${_suppliers[index]['name']}'),
          TableLikeListTextDataCell('${_suppliers[index]['number']}'),
          TableLikeListTextDataCell('${_suppliers[index]['email']}'),
          TableLikeListTextDataCell('${_suppliers[index]['address']}'),
        ]),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreen(context, index) {
    String mobile = _suppliers[index]['number'] ?? '';
    String email = _suppliers[index]['email'] ?? '';
    String name = _suppliers[index]['name'] ?? '';
    var style = const TextStyle(
      fontWeight: FontWeight.w300,
      overflow: TextOverflow.ellipsis,
      fontSize: 16,
      color: Color(0xFF1C1C1C),
    );
    var sub_style = const TextStyle(
      fontWeight: FontWeight.w200,
      overflow: TextOverflow.ellipsis,
      fontSize: 14,
      color: Color(0xFF626262),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: BodyLarge(text: name),
          subtitle: mobile.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: LabelLarge(text: '$mobile - $email', overflow: TextOverflow.ellipsis),
                ),
        ),
        const SizedBox(height: 5),
        const HorizontalLine(),
      ],
    );
  }
}
