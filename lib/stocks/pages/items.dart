import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/stocks/states/items_loading.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/table_context_menu.dart';
import '../../core/components/table_like_list.dart';
import '../../core/components/top_bar.dart';
import '../../core/models/menu.dart';
import '../../core/services/util.dart';
import '../components/create_item_content.dart';
import '../services/item.dart';
import '../states/items_list.dart';

class ItemsPage extends StatefulWidget {
  final args;

  const ItemsPage(this.args, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsPage();
}

class _ItemsPage extends State<ItemsPage> {
  _appBar(context) {
    return StockAppBar(
      title: "Items",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: getState<ItemsListState>().updateQuery,
      searchHint: 'Search...',
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () => showDialog(
          context: context,
          builder: (c) => Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Dialog(
                child: createItemContent(),
              ),
            ),
          ),
        ),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          getState<ItemsLoadingState>().update(true);
        },
      ),
    ];
  }

  _tableHeader() => tableLikeListRow(
        [
          tableLikeListTextHeader('Brand'),
          tableLikeListTextHeader('Generic'),
          tableLikeListTextHeader('Packaging'),
        ],
      );

  _fields() => ['brand', 'generic', 'packaging'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  Widget build(context) => responsiveBody(
        menus: moduleMenus(),
        current: '/stock/',
        onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              tableContextMenu(_contextItems(context)),
              Consumer<ItemsLoadingState>(
                builder: (_, state) => _loading(state.loading),
              ),
              _tableHeader(),
              Consumer<ItemsListState>(
                builder: (_, state) => Expanded(
                  child: tableLikeList(
                    onFuture: () async => getItemFromCacheOrRemote(
                      stringLike: state.query,
                      skipLocal: widget.args.queryParams.containsKey('reload'),
                    ),
                    keys: _fields(),
                    // onCell: (key,data)=>Text('@$data')
                  ),
                ),
              ),
              // _tableFooter()
            ],
          ),
        ),
      );

  @override
  void dispose() {
    getState<ItemsListState>().updateQuery('');
    super.dispose();
  }
}
