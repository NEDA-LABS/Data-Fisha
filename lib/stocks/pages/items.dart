import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/components/top_bar.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_item_content.dart';
import 'package:smartstock/stocks/services/item.dart';
import 'package:smartstock/stocks/states/items_list.dart';
import 'package:smartstock/stocks/states/items_loading.dart';

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
                      child: Dialog(child: createItemContent()))))),
      ContextMenu(
          name: 'Reload',
          pressed: () {
            getState<ItemsLoadingState>().update(true);
          })
    ];
  }

  _tableHeader() => tableLikeListRow([
        tableLikeListTextHeader('Brand'),
        tableLikeListTextHeader('Generic'),
        tableLikeListTextHeader('Packaging'),
      ]);

  _fields() => ['brand', 'generic', 'packaging'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  Widget build(context) => responsiveBody(
      menus: moduleMenus(),
      current: '/stock/',
      onBody: (d) => Scaffold(
          appBar: _appBar(context),
          body:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                            skipLocal:
                                widget.args.queryParams.containsKey('reload')),
                        keys: _fields())))
          ])));

  @override
  void dispose() {
    getState<ItemsListState>().updateQuery('');
    super.dispose();
  }
}
