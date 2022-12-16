import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/responsive_body.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';

class CategoriesPage extends StatefulWidget {
  final args;

  const CategoriesPage(this.args, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CategoriesPage> {
  bool _isLoading = false;
  String _query = '';
  List _categories = [];

  _appBar(context) {
    return StockAppBar(
      title: "Categories",
      showBack: true,
      backLink: '/stock/',
      showSearch: true,
      onSearch: (p0) {
        setState(() {
          _query = p0;
          getCategoryFromCacheOrRemote(skipLocal: false).then((value) {
            _categories = value
                .where((element) => '${element['name']}'
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
                .toList();
          }).whenComplete(() => setState(() {}));
        });
      },
      searchHint: 'Search...',
      context: context,
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
                child: CreateCategoryContent(),
              ),
            ),
          ),
        ),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchCategories();
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
  void initState() {
    _fetchCategories();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        menus: moduleMenus(),
        current: '/stock/',
        sliverAppBar: _appBar(context),
        onBody: (d) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            tableContextMenu(_contextItems(context)),
            _loading(_isLoading),
            _tableHeader(),
            Expanded(
              child: TableLikeList(
                onFuture: () async => _categories,
                keys: _fields(),
                // onCell: (key,data)=>Text('@$data')
              ),
            ),
            // _tableFooter()
          ],
        ),
      );

  _fetchCategories() {
    setState(() {
      _isLoading = true;
    });
    getCategoryFromCacheOrRemote(skipLocal: true).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}
