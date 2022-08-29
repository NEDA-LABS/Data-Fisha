import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/stocks/states/suppliers_loading.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/table_context_menu.dart';
import '../../core/components/table_like_list.dart';
import '../../core/components/top_bar.dart';
import '../../core/models/menu.dart';
import '../../core/services/util.dart';
import '../components/create_supplier_content.dart';
import '../services/supplier.dart';
import '../states/suppliers_list.dart';

class SuppliersPage extends StatefulWidget {
  final args;

  const SuppliersPage(this.args, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SuppliersPage();
}

class _SuppliersPage extends State<SuppliersPage> {
  _appBar(context) {
    return StockAppBar(
      title: "Suppliers",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: getState<SuppliersListState>().updateQuery,
      searchHint: 'Search...',
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
              child: Dialog(
                child: createSupplierContent(),
              ),
            ),
          ),
        ),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          getState<SuppliersLoadingState>().update(true);
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

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextItems(context)),
              Consumer<SuppliersLoadingState>(
                builder: (_, state) => _loading(state.loading),
              ),
              _tableHeader(),
              Consumer<SuppliersListState>(
                builder: (_, state) => Expanded(
                  child: tableLikeList(
                    onFuture: () async => getSupplierFromCacheOrRemote(
                      stringLike: state.query,
                      skipLocal: widget.args.queryParams.containsKey('reload'),
                    ),
                    keys: _fields(),
                    // onCell: (key,data)=>Text('@$data')
                  ),
                ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );

  @override
  void dispose() {
    getState<SuppliersListState>().updateQuery('');
    super.dispose();
  }
}
