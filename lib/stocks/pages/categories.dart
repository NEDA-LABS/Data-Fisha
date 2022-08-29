import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/stocks/states/categories_loading.dart';

import '../../app.dart';
import '../../core/components/responsive_body.dart';
import '../../core/components/table_context_menu.dart';
import '../../core/components/table_like_list.dart';
import '../../core/components/top_bar.dart';
import '../../core/models/menu.dart';
import '../../core/services/util.dart';
import '../components/create_category_content.dart';
import '../services/category.dart';
import '../states/categories_list.dart';

class CategoriesPage extends StatefulWidget {
  final args;

  const CategoriesPage(this.args, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CategoriesPage();
}

class _CategoriesPage extends State<CategoriesPage> {
  _appBar(context) {
    return StockAppBar(
      title: "Categories",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: getState<CategoriesListState>().updateQuery,
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
                child: createCategoryContent(),
              ),
            ),
          ),
        ),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          getState<CategoriesLoadingState>().update(true);
        },
      ),
    ];
  }

  _tableHeader() => tableLikeListRow([
        tableLikeListTextHeader('Name'),
        tableLikeListTextHeader('Description'),
      ]);

  _fields() => ['name', 'description'];

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
              Consumer<CategoriesLoadingState>(
                builder: (_, state) => _loading(state.loading),
              ),
              _tableHeader(),
              Consumer<CategoriesListState>(
                builder: (_, state) => Expanded(
                  child: tableLikeList(
                    onFuture: () async => getCategoryFromCacheOrRemote(
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
    getState<CategoriesListState>().updateQuery('');
    super.dispose();
  }
}
