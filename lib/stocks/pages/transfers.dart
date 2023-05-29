import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/date.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/transfer_details.dart';
import 'package:smartstock/stocks/services/transfer.dart';

class TransfersPage extends StatefulWidget {
  const TransfersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TransfersPage();
}

class _TransfersPage extends State<TransfersPage> {
  bool _loading = false;
  final String _date = toSqlDate(DateTime.now());
  List _transfers = [];

  _appBar(context) => getSliverSmartStockAppBar(
      title: "Transfers",
      showBack: true,
      backLink: '/stock/',
      showSearch: false,
      onBack: (){
        Navigator.of(context).maybePop();
      },
      context: context);

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

  _tableHeader() => const SizedBox(
        height: 38,
        child: TableLikeListRow([
          TableLikeListTextHeaderCell('Date'),
          TableLikeListTextHeaderCell('Type'),
          TableLikeListTextHeaderCell('Amount')
        ]),
      );

  _loadingView(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _refresh();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/stock/',
        sliverAppBar: _appBar(context),
        loading: _loading,
        onLoadMore: () async => _loadMore(),
        staticChildren: [
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextTransfers(context)),
          _loadingView(_loading),
          getIsSmallScreen(context) ? Container() : _tableHeader(),
        ],
        totalDynamicChildren: _transfers.length,
        dynamicChildBuilder:
            getIsSmallScreen(context) ? _smallScreenView : _largerScreenView,
        fab: FloatingActionButton(
          onPressed: () => _showMobileContextMenu(context),
          child: const Icon(Icons.unfold_more_outlined),
        ),
      );

  _refresh({skip = false}) {
    setState(() {
      _loading = true;
    });
    getTransfersRemote(_date).then((value) {
      _transfers = value;
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  _renderDateCell(b, other) {
    var f = DateFormat('yyyy-MM-dd HH:mm');
    var date = f.format(DateTime.parse(b));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              'Shop:  $other',
              style: const TextStyle(fontSize: 12, color: Color(0xFF939393)),
            ),
          ),
          // Padding(
          //   padding:
          //   const EdgeInsets.symmetric(vertical: 3.0),
          //   child: Text('To: ${c['to_shop']['name']}'),
          // )
        ],
      ),
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
                leading: const Icon(Icons.call_made_outlined),
                title: const Text('Send'),
                onTap: () => navigateTo('/stock/transfers/send'),
              ),
              HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.call_received),
                title: const Text('Receive'),
                onTap: () => navigateTo('/stock/transfers/receive'),
              ),
              HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload transfers'),
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

  _loadMore() {
    if (_transfers.isNotEmpty) {
      var last = _transfers.last;
      setState(() {
        _loading = true;
      });
      var updatedAt = last['updatedAt'] ?? toSqlDate(DateTime.now());
      getTransfersRemote(updatedAt).then((value) {
        _transfers.addAll(value);
      }).whenComplete(() {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  Widget _largerScreenView(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            showDialogOrModalSheet(
                transferDetails(context, _transfers[index]), context);
          },
          child: TableLikeListRow([
            _renderDateCell(
                _transfers[index]['date'], _transfers[index]['otherShop']),
            TableLikeListTextDataCell('${_transfers[index]['type']}'),
            TableLikeListTextDataCell(
                '${formatNumber(_transfers[index]['amount'])}'),
            // Center(child: _getStatusView(_purchases[index]))
          ]),
        ),
        HorizontalLine()
      ],
    );
  }

  Widget _smallScreenView(context, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () => showDialogOrModalSheet(
              transferDetails(context, _transfers[index]), context),
          contentPadding: const EdgeInsets.symmetric(horizontal: 2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TableLikeListTextDataCell(
                  '${toSqlDate(DateTime.tryParse(_transfers[index]['date']) ?? DateTime.now())}'),
              Text('${compactNumber(_transfers[index]['amount'])}')
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_transfers[index]['otherShop']}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                '${_transfers[index]['type']}',
                style: const TextStyle(fontSize: 13),
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        HorizontalLine(),
      ],
    );
  }
}
