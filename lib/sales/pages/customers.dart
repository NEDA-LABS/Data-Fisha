import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/table_context_menu.dart';
import '../../core/components/table_like_list.dart';
import '../../core/components/top_bar.dart';
import '../../core/models/menu.dart';
import '../components/create_customer_content.dart';
import '../services/customer.dart';

class CustomersPage extends StatefulWidget {
  final args;

  const CustomersPage(this.args, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomersPage();
}

class _CustomersPage extends State<CustomersPage> {
  _appBar(context) => StockAppBar(
      title: "Customers",
      showBack: true,
      backLink: '/sales/',
      showSearch: true,
      onSearch: (d) {},
      searchHint: 'Search...');

  _contextCustomers(context) => [
        ContextMenu(
            name: 'Create',
            pressed: () => showDialog(
                context: context,
                builder: (c) => Center(
                    child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Dialog(child: createCustomerContent()))))),
        ContextMenu(name: 'Reload', pressed: () {})
      ];

  _tableHeader() => tableLikeListRow(
        [
          tableLikeListTextHeader('Name'),
          tableLikeListTextHeader('Phone'),
          tableLikeListTextHeader('Email'),
        ],
      );

  _fields() => ['displayName', 'phone', 'email'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/sales/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextCustomers(context)),
              _loading(false),
              _tableHeader(),
              Expanded(
                child: tableLikeList(
                  onFuture: () async => getCustomerFromCacheOrRemote(
                    stringLike: '',
                    skipLocal: widget.args.queryParams.containsKey('reload'),
                  ),
                  keys: _fields(),
                ),
              ), // _tableFooter()
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }
}
