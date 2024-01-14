import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/services/api_product.dart';

class ProductMovementDetails extends StatefulWidget {
  final dynamic item;

  const ProductMovementDetails({
    this.item,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductMovementDetails> {
  Map states = {};
  var _updateState;

  @override
  void initState() {
    _updateState = ifDoElse(
        (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _future(widget.item),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('${snapshot.error}'),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton(
                      onPressed: () => _updateState({'a': 1}),
                      child: const Text('Retry')),
                )
              ],
            ),
          );
        }
        return ListView(
          shrinkWrap: true,
          children: [
            _header(context, widget.item),
            _tableHeader(),
            ...itOrEmptyArray(snapshot.data)
                .reversed
                .toList()
                .map<Widget>((item) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TableLikeListRow([
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Text('${_getDate(item[0])}')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${item[5]}'),
                          ),
                          paddingText(item[4]),
                          paddingText(item[1]),
                          paddingText(item[4] - item[1]),
                        ]),
                        const HorizontalLine()
                      ],
                    ))
                .toList(),
            const SizedBox(height: 24)
          ],
        );
      },
    );
  }

  paddingText(item) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${doubleOrZero('$item')}'),
      );

  _getDate(data) {
    var format = DateFormat('yyyy-MM-dd HH:mm');
    var time = DateTime.fromMillisecondsSinceEpoch(int.tryParse('$data') ?? 0);
    return format.format(time);
  }

  Future<dynamic> _future(item) async {
    var shop = await getActiveShop();
    return productMovementRestAPI(id: item['id'], shop: shop);
    // return fn;
  }

  _tableHeader() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16),
        child: SizedBox(
          height: 38,
          child: TableLikeListRow([
            TableLikeListHeaderCell('Date'),
            TableLikeListHeaderCell('Source'),
            TableLikeListHeaderCell('Close'),
            TableLikeListHeaderCell('Open'),
            TableLikeListHeaderCell('Move'),
          ]),
        ),
      );

  _header(context, item) => Container(
        height: 50,
        color: Theme.of(context).primaryColorDark,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: Text(
              'Movements of ${item['product']}',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )),
            // Text(
            //   '${item['product']}',
            //   style: const TextStyle(color: Colors.white, fontSize: 16),
            // )
          ],
        ),
      );
}
