import 'package:bfast/util.dart';
import 'package:flutter/material.dart';

_errorAndRetry(String err) => Padding(
    padding: const EdgeInsets.all(10),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(err)]));

_tableRow(item, List<String> keys, Widget Function(String, dynamic) onCell,
        onItemPressed) =>
    Column(children: [
      Container(
          constraints: const BoxConstraints(minHeight: 48),
          child: InkWell(
              onTap: () => onItemPressed(item),
              child: tableLikeListRow(keys
                  .map((k) => onCell != null
                      ? onCell(k, item[k] ?? '')
                      : Text('${item[k] ?? ''}'))
                  .toList()))),
      const Divider(height: 2)
    ]);

_tableRows(List data, context, List<String> keys, onCell, onItemPressed) =>
    SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) =>
                _tableRow(data[index], keys, onCell, onItemPressed)));

_showErrorOrContent(context, List<String> keys, onCell, onItemPressed) =>
    ifDoElse(
      (x) => x.hasError,
      (x) => _errorAndRetry('${x.error}'),
      (x) => _tableRows(x.data, context, keys, onCell, onItemPressed),
    );

Widget Function(BuildContext, AsyncSnapshot) _builder(
        List<String> keys, onCell, onItemPressed) =>
    (context, snapshot) {
      var builder = ifDoElse(
        (x) => snapshot.connectionState == ConnectionState.waiting,
        (x) => const Text('Loading...'),
        _showErrorOrContent(context, keys, onCell, onItemPressed),
      );
      return builder(snapshot);
    };

Widget tableLikeListRow(List<Widget> items) => Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
          children: items
              .map((e) =>
                  Expanded(flex: items.indexOf(e) == 0 ? 3 : 1, child: e))
              .toList()),
    );

tableLikeListTextHeader(String name) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Text(
        name,
        style: const TextStyle(
            // fontSize: 16,
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.ellipsis),
      ),
    );

_a(dynamic) {}

tableLikeList({
  @required Future Function() onFuture,
  @required List<String> keys,
  onItemPressed = _a,
  Widget Function(String key, dynamic data) onCell,
}) =>
    FutureBuilder(
        future: onFuture(), builder: _builder(keys, onCell, onItemPressed));
