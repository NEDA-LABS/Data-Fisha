import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/stocks/components/create_supplier_content.dart';
import 'package:smartstock/stocks/services/supplier.dart';

class SuppliersPage extends StatefulWidget {
  final args;

  const SuppliersPage(this.args, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SuppliersPage> {
  bool _isLoading = false;
  String _query = '';
  List _suppliers = [];

  _appBar(context) {
    return StockAppBar(
      title: "Suppliers",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: (p0) {
        setState(() {
          _query = p0;
          getSupplierFromCacheOrRemote(skipLocal: false).then((value) {
            _suppliers = value
                .where((element) => '${element['name']}'
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
                .toList();
          }).whenComplete(() => setState(() {}));
        });
      },
      searchHint: 'Search...',
      context: context,
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () => showDialog(
          context: context,
          builder: (c) => Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Dialog(
                child: CreateSupplierContent(),
              ),
            ),
          ),
        ),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchSuppliers();
        },
      ),
    ];
  }

  _tableHeader() => tableLikeListRow([
        tableLikeListTextHeader('Name'),
        tableLikeListTextHeader('Mobile'),
        tableLikeListTextHeader('Email'),
        tableLikeListTextHeader('Address'),
      ]);

  _fields() => ['name', 'number', 'email', 'address'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  _fetchSuppliers() {
    setState(() {
      _isLoading = true;
    });
    getSupplierFromCacheOrRemote(skipLocal: true)
        .then((value) {
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
        menus: moduleMenus(),
        current: '/stock/',
        sliverAppBar: _appBar(context),
        onBody: (d) => Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextItems(context)),
              _loading(_isLoading),
              _tableHeader(),
              Expanded(
                child: TableLikeList(
                  onFuture: () async => _suppliers,
                  keys: _fields(),
                  // onCell: (key,data)=>Text('@$data')
                ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );
}
