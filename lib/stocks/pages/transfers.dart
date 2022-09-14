import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/transfer_details.dart';
import 'package:smartstock/stocks/services/transfer.dart';

class TransfersPage extends StatefulWidget {
  final args;

  const TransfersPage(this.args, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransfersPage();
}

class _TransfersPage extends State<TransfersPage> {
  bool _loading = false;
  String _query = '';
  List? _transfers = [];

  _appBar(context) => StockAppBar(
      title: "Transfers",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: (d) {
        setState(() {
          _query = d;
        });
        _refresh(skip: false);
      },
      searchHint: 'Search...');

  _contextTransfers(context) => [
        ContextMenu(
          name: 'Send',
          pressed: () => navigateTo('/stock/transfers/send'),
        ),
        ContextMenu(
          name: 'Receive',
          pressed: () => navigateTo('/stock/transfers/receive'),
        ),
        ContextMenu(name: 'Reload', pressed: () => _refresh(skip: true))
      ];

  _tableHeader() => SizedBox(
        height: 38,
        child: tableLikeListRow([
          tableLikeListTextHeader('Date'),
          tableLikeListTextHeader('Type'),
          tableLikeListTextHeader('Amount')
        ]),
      );

  _fields() => [
        'date',
        'type',
        'amount',
      ];

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextTransfers(context)),
              _loadingView(_loading),
              _tableHeader(),
              Expanded(
                child: tableLikeList(
                    onFuture: () async => _transfers,
                    keys: _fields(),
                    onCell: (a, b, c) {
                      if (a == 'date') {
                        var f = DateFormat('yyyy-MM-dd HH:mm');
                        var date = f.format(DateTime.parse(b));
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(
                                  date,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text('From: ${c['from_shop']['name']}'),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Text('To: ${c['to_shop']['name']}'),
                              )
                            ],
                          ),
                        );
                      }
                      if(a=='type'){
                        return Text('$b'.isNotEmpty?b:'Send');
                      }
                      return Text('$b');
                    },
                    onItemPressed: (item) => showDialogOrModalSheet(
                        transferDetails(context, item), context)),
              ), // _tableFooter()
            ],
          ),
        ),
      );

  _refresh({skip = false}) {
    setState(() {
      _loading = true;
    });
    getTransferFromCacheOrRemote(
      stringLike: _query,
      skipLocal: widget.args.queryParams.containsKey('reload') || skip,
    ).then((value) {
      setState(() {
        _transfers = value;
      });
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
