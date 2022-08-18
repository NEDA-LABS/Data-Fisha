import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/core/components/active_component.dart';
import 'package:smartstock_pos/core/services/stocks.dart';
import 'package:smartstock_pos/core/services/util.dart';

_loading() => const SizedBox(
      height: 5,
      child: LinearProgressIndicator(),
    );

_errorAndRetry(String err, state) => Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(err),
          OutlinedButton(onPressed: () => state(), child: const Text('Retry'))
        ],
      ),
    );

_tableHeadColumn(String name) => DataColumn(
      label: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
    );

_dataAndRefresh(List data, updateState) => PaginatedDataTable(
      columns: [
        _tableHeadColumn('Products'),
        _tableHeadColumn('Quantity'),
        _tableHeadColumn('Purchase ( Tsh )'),
        _tableHeadColumn('Retail ( Tsh )'),
        _tableHeadColumn('Wholesale ( Tsh )'),
      ],
      rowsPerPage: 50,
      source: _DataTable(data),
    );

_showErrorOrContent(updateState) => ifDoElse(
      (x) => x.hasError,
      (x) => _errorAndRetry('${x.error}', updateState),
      (x) => _dataAndRefresh(x.data, updateState),
    );

Widget Function(BuildContext context, AsyncSnapshot snapshot) _builder(
  update,
) =>
    (context, snapshot) {
      var builder = ifDoElse(
        (x) => snapshot.connectionState == ConnectionState.waiting,
        (x) => _loading(),
        _showErrorOrContent(update),
      );
      return builder(snapshot);
    };

Widget _activeBuilder(Map states, Function(Map data) update) => FutureBuilder(
    future: getStockFromCacheOrRemote(), builder: _builder(update));

desktopTable() => const ActiveComponent(_activeBuilder);

class _DataTable extends DataTableSource {
  final List data;

  _DataTable(this.data);

  @override
  DataRow getRow(int index) => DataRow(cells: [
    DataCell(Text(data[index]['product'].toString())),
    DataCell(Text(getStockQuantity(stock: data[index]).toString())),
    DataCell(Text(data[index]['purchase'].toString())),
    DataCell(Text(data[index]['retailPrice'].toString())),
    DataCell(Text(data[index]['wholesalePrice'].toString())),
  ]);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
