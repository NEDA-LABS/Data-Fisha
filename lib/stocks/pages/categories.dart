import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/api_categories.dart';
import 'package:smartstock/stocks/services/category.dart';

class CategoriesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const CategoriesPage({
    Key? key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(key: key, pageName: 'CategoriesPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CategoriesPage> {
  bool _isLoading = false;
  String _query = '';
  List _categories = [];

  _appBar(context) {
    return SliverSmartStockAppBar(
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        staticChildren: [
          getIsSmallScreen(context)
              ? Container()
              : getTableContextMenu(_contextItems(context)),
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
                    firstLetterUpperCase('${_categories[index]['name']}')),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 60,
                    // height: 60,
                    child: Image.network(
                      '${_categories[index]['image']}',
                      errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDeleteDialogHelper(
                        context: context,
                        name: firstLetterUpperCase(
                            '${_categories[index]['name']}'),
                        onDelete: () {
                          return _deleteCategory('${_categories[index]['id']}');
                        });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                // subtitle: Text(
                //   '${_categories[index]['description']}',
                //   style: const TextStyle(
                //       fontSize: 12, fontWeight: FontWeight.w300),
                // ),
              ),
              // const SizedBox(height: 5),
              const HorizontalLine(),
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
              const HorizontalLine(),
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
          constraints: const BoxConstraints(maxWidth: 800),
          child: Dialog(
            child: CreateCategoryContent(onNewCategory: (category) {

            },),
          ),
        ),
      ),
    ).whenComplete(() {
      _fetchCategories();
    });
  }

  Future _deleteCategory(id) async {
    var shop = await getActiveShop();
    var deleteCategory = prepareDeleteCategoryAPI(id);
    await deleteCategory(shop);
    _fetchCategories();
  }
}
