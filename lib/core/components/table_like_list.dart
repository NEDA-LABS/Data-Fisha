import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/horizontal_line.dart';

Widget tableLikeListRow(List<Widget> items) {
  _map(e) => Expanded(flex: items.indexOf(e) == 0 ? 2 : 1, child: e);
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
    child: Row(children: items.map(_map).toList()),
  );
}

tableLikeListTextHeader(String name) {
  var style = const TextStyle(
      fontWeight: FontWeight.w300, overflow: TextOverflow.ellipsis, color: Color(
      0x66000000));
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(name, style: style),
  );
}

_a(dynamic) {}
// Future _m() async {}

class TableLikeList extends StatefulWidget {
  final Future Function() onFuture;
  final List<String> keys;
  final Widget Function(String key, dynamic, dynamic)? onCell;
  final Function(dynamic) onItemPressed;
  final Future Function()? onLoadMore;
  final bool loading;

  const TableLikeList({
    required this.onFuture,
    required this.keys,
    this.onLoadMore,
    this.onItemPressed = _a,
    this.onCell,
    Key? key,
    this.loading = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TableLikeList> {
  late ScrollController controller;

  // bool isLoadMore = false;

  // ScrollDirection scrollDirection = ScrollDirection.forward;

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.onFuture(),
      builder: _prepareBuilder(
        widget.keys,
        widget.onCell,
        widget.onItemPressed,
      ),
    );
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 50
        // &&
        // scrollDirection == ScrollDirection.reverse
        ) {
      _loadMore();
    }
  }

  _errorAndRetry(String err) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(err)],
      ),
    );
  }

  _tableRow(item, List<String> keys, onCell, onItemPressed) {
    keyToView(k) => onCell != null
        ? onCell(k, item[k] ?? '', item) as Widget
        : Text('${item[k] ?? ''}');
    return Column(children: [
      Container(
        constraints: const BoxConstraints(minHeight: 48),
        child: InkWell(
          onTap: () => onItemPressed(item),
          child: tableLikeListRow(keys.map(keyToView).toList()),
        ),
      ),
      horizontalLine()
    ]);
  }

  _tableRows(List data, context, List<String> keys, onCell, onPress) {
    return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data.isNotEmpty ? data.length + 1 : data.length,
        itemBuilder: (context, index) {
          var getRow = ifDoElse(
            (i) => data.length == i,
            (_) => _loadMoreView(),
            (i) => _tableRow(data[i], keys, onCell, onPress),
          );
          return getRow(index);
        });
  }

  _showErrorOrContent(context, List<String> keys, onCell, onPress) {
    return ifDoElse(
      (x) => x.hasError,
      (x) => _errorAndRetry('${x.error}'),
      (x) => _tableRows(x.data ?? [], context, keys, onCell, onPress),
    );
  }

  Widget Function(BuildContext, AsyncSnapshot) _prepareBuilder(
    List<String> keys,
    onCell,
    onPress,
  ) {
    return (context, snapshot) {
      var builder =
          _showErrorOrContent(context, keys, onCell, onPress);
      return builder(snapshot);
    };
  }

  _loadMoreView() {
    if (widget.onLoadMore == null) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: OutlinedButton(
          onPressed: widget.loading ? null : _loadMore,
          child: Text(widget.loading ? 'Waiting...' : 'Load more'),
        ),
      ),
    );
  }

  _loadMore() {
    if (widget.loading == true) {
      if (kDebugMode) {
        print('ON LOADING....');
      }
      return;
    }
    if (widget.onLoadMore != null) {
      // setState(() {
      //   isLoadMore = true;
      // });
      if (kDebugMode) {
        print('LOAD MORE.');
      }
      widget.onLoadMore!().catchError((err) {
        if (kDebugMode) {
          print(err);
        }
      }).whenComplete(() {
        // setState(() {
        //   isLoadMore = false;
        // });
      });
    }
  }
}
