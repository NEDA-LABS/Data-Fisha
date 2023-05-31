import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/navigation.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/services/customer.dart';

class CustomersPage extends StatefulWidget {
  final OnBackPage onBackPage;

  const CustomersPage({Key? key, required this.onBackPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomersPage();
}

class _CustomersPage extends State<CustomersPage> {
  bool _loading = false;
  String _query = '';
  List _customers = [];

  _appBar(context) {
    return getSliverSmartStockAppBar(
        title: "Customers",
        showBack: true,
        backLink: '/sales/',
        showSearch: true,
        onBack: widget.onBackPage,
        onSearch: (d) {
          setState(() {
            if (mounted) {
              _query = d;
            }
          });
          _refresh(skip: false);
        },
        searchHint: 'Search...',
        context: context);
  }

  _contextCustomers(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: _createDialog,
      ),
      ContextMenu(name: 'Reload', pressed: () => _refresh(skip: true))
    ];
  }

  _tableHeader() {
    return const SizedBox(
      height: 38,
      child: TableLikeListRow([
        TableLikeListTextHeaderCell('Name'),
        TableLikeListTextHeaderCell('Phone'),
        TableLikeListTextHeaderCell('Email'),
      ]),
    );
  }

  _loadingView(bool show) {
    return show ? const LinearProgressIndicator(minHeight: 4) : Container();
  }

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/sales/',
      sliverAppBar: _appBar(context),
      staticChildren: [
        getIsSmallScreen(context)
            ? Container()
            : tableContextMenu(_contextCustomers(context)),
        _loadingView(_loading),
        getIsSmallScreen(context) ? Container() : _tableHeader(),
      ],
      totalDynamicChildren: _customers.length,
      dynamicChildBuilder:
          getIsSmallScreen(context) ? _smallScreen : _largerScreen,
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined),
      ),
    );
  }

  _refresh({skip = false}) {
    setState(() {
      _loading = true;
    });
    getCustomerFromCacheOrRemote(
      stringLike: _query,
      skipLocal: skip,
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

  Widget _largerScreen(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableLikeListRow([
          TableLikeListTextDataCell('${_customers[index]['displayName']}'),
          TableLikeListTextDataCell('${_customers[index]['phone']}'),
          TableLikeListTextDataCell('${_customers[index]['email']}'),
        ]),
        const HorizontalLine()
      ],
    );
  }

  Widget _smallScreen(context, index) {
    return Column(
      children: [
        ListTile(
          title: Text(
            '${_customers[index]['displayName']}',
            style:
                const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_customers[index]['phone']}',
                style: const TextStyle(
                    overflow: TextOverflow.ellipsis, fontSize: 13),
              ),
              '${_customers[index]['email'] ?? ''}'.isNotEmpty
                  ? Text(
                      '${_customers[index]['email']}',
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis, fontSize: 13),
                    )
                  : Container()
            ],
          ),
        ),
        const HorizontalLine()
      ],
    );
  }

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
                title: const Text('Create customer'),
                onTap: _createDialog,
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload customers'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _refresh();
                },
              ),
            ],
          ),
        ),
        context);
  }

  _createDialog() {
    showDialog(
      context: context,
      builder: (c) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const Dialog(child: CreateCustomerContent()),
        ),
      ),
    );
  }
}
