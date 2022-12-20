import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/services/customer.dart';

class CustomersPage extends StatefulWidget {
  final args;

  const CustomersPage(this.args, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomersPage();
}

class _CustomersPage extends State<CustomersPage> {
  bool _loading = false;
  String _query = '';
  List? _customers = [];

  _appBar(context) => StockAppBar(
      title: "Customers",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onSearch: (d) {
        setState(() {
          _query = d;
        });
        _refresh(skip: false);
      },
      searchHint: 'Search...', context: context);

  _contextCustomers(context) => [
        ContextMenu(
          name: 'Create',
          pressed: () => showDialog(
            context: context,
            builder: (c) => Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Dialog(child: CreateCustomerContent()),
              ),
            ),
          ),
        ),
        ContextMenu(name: 'Reload', pressed: () => _refresh(skip: true))
      ];

  _tableHeader() => SizedBox(
    height: 38,
    child: TableLikeListRow([
          TableLikeListTextHeaderCell('Name'),
          TableLikeListTextHeaderCell('Phone'),
          TableLikeListTextHeaderCell('Email'),
        ]),
  );

  _fields() => ['displayName', 'phone', 'email'];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        menus: moduleMenus(),
        current: '/sales/',
        sliverAppBar: _appBar(context),
        onBody: (d) => Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextCustomers(context)),
              _loadingView(_loading),
              _tableHeader(),
              Expanded(
                child: TableLikeList(
                  onFuture: () async => _customers,
                  keys: _fields(),
                ),
              ), // _tableFooter()
            ],
          ),
        ),
      );

  _refresh({skip = false}) {
    setState(() {
      _loading = true;
    });
    getCustomerFromCacheOrRemote(
      stringLike: _query,
      skipLocal: widget.args.queryParams.containsKey('reload') || skip,
    ).then((value) {
      setState(() {
        _customers = value;
      });
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
