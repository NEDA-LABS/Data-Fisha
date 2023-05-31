import 'package:flutter/material.dart';
import 'package:smartstock/app.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';

class CategoriesPage extends StatefulWidget {
  final OnBackPage onBackPage;

  const CategoriesPage({
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CategoriesPage> {
  bool _isLoading = false;
  String _query = '';
  List _categories = [];

  _appBar(context) {
    return getSliverSmartStockAppBar(
      title: "Categories",
      showBack: true,
      showSearch: true,
      onBack: widget.onBackPage,
      onSearch: (p0) {
        if (p0.startsWith('-1:') == false) {
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
        }
      },
      searchHint: 'Search...',
      context: context,
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(
        name: 'Create',
        pressed: () => _createCategory(),
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchCategories();
        },
      ),
    ];
  }

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  @override
  void initState() {
    _fetchCategories();
    super.initState();
  }

  @override
  Widget build(context) => ResponsivePage(
        current: '/stock/',
        sliverAppBar: _appBar(context),
        staticChildren: [
          getIsSmallScreen(context)
              ? Container()
              : tableContextMenu(_contextItems(context)),
          _loading(_isLoading),
          // _tableHeader(),
        ],
        dynamicChildBuilder: (context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                  title: TableLikeListTextDataCell(
                      '${_categories[index]['name']}'),
                  subtitle: Text(
                    '${_categories[index]['description']}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                  )),
              const SizedBox(height: 5),
              HorizontalLine(),
            ],
          );
        },
        fab: FloatingActionButton(
          onPressed: () => _showMobileContextMenu(context),
          child: const Icon(Icons.unfold_more_outlined),
        ),
        totalDynamicChildren: _categories.length,
      );

  _fetchCategories() {
    setState(() {
      _isLoading = true;
    });
    getCategoryFromCacheOrRemote(skipLocal: true).then(
      (value) {
        _categories = value;
      },
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
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
                leading: const Icon(Icons.add),
                title: const Text('Create category'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _createCategory());
                },
              ),
              HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload categories'),
                onTap: () {
                  Navigator.of(context).maybePop();
                  _fetchCategories();
                },
              ),
            ],
          ),
        ),
        context);
  }

  _createCategory() {
    showDialog(
      context: context,
      builder: (c) => Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: const Dialog(
            child: CreateCategoryContent(),
          ),
        ),
      ),
    );
  }
}
