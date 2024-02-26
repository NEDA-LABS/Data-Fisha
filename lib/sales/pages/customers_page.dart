import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/sales/components/create_customer_content.dart';
import 'package:smartstock/sales/services/customers.dart';

class CustomersPage extends PageBase {
  final OnBackPage onBackPage;

  const CustomersPage({super.key, required this.onBackPage})
      : super(pageName: 'CustomersPage');

  @override
  State<StatefulWidget> createState() => _CustomersPage();
}

class _CustomersPage extends State<CustomersPage> {
  bool _loading = false;
  String _query = '';
  List _customers = [];

  _appBar(context) {
    return SliverSmartStockAppBar(
        title: "Customers",
        showBack: true,
        backLink: '/sales/',
        showSearch: true,
        onBack: widget.onBackPage,
        onSearch: (d) {
          if (d.startsWith('-1:') == false) {
            setState(() {
              if (mounted) {
                _query = d;
              }
            });
            _refresh(skip: false);
          }
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
        TableLikeListHeaderCell('Name'),
        TableLikeListHeaderCell('Phone'),
        TableLikeListHeaderCell('Email'),
      ]),
    );
  }

  _loadingView(bool show) {
    return show ? const LinearProgressIndicator(minHeight: 4) : Container();
  }

  @override
  void initState() {
    _refresh(skip: false);
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/sales/',
      backgroundColor: Theme.of(context).colorScheme.surface,
      sliverAppBar: _appBar(context),
      staticChildren: [
        getIsSmallScreen(context)
            ? Container()
            : getTableContextMenu(_contextCustomers(context)),
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

  _refresh({skip = true}) {
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
          title: BodyLarge(
              text: '${_customers[index]['displayName']}',
              overflow: TextOverflow.ellipsis),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabelLarge(
                text: '${_customers[index]['phone']}',
                overflow: TextOverflow.ellipsis,
              ),
              '${_customers[index]['email'] ?? ''}'.isNotEmpty
                  ? LabelLarge(
                      text: '${_customers[index]['email']}',
                      overflow: TextOverflow.ellipsis,
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
                title: const BodyLarge(text: 'Create customer'),
                onTap: _createDialog,
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload customers'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _refresh(skip: true);
                },
              ),
            ],
          ),
        ),
        context);
  }

  _createDialog() {
    showDialogOrFullScreenModal(
      Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: CreateCustomerContent(
          onDone: () {
            _refresh(skip: true);
          },
        ),
      ),
      context,
    );
  }
}
