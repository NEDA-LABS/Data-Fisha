import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/LabelMedium.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/helpers/dialog.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/helpers/dialog_or_fullscreen.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/api_categories.dart';
import 'package:smartstock/stocks/services/category.dart';

class CategoriesPage extends PageBase {
  final OnBackPage onBackPage;
  final OnChangePage onChangePage;

  const CategoriesPage({
    super.key,
    required this.onBackPage,
    required this.onChangePage,
  }) : super(pageName: 'CategoriesPage');

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
            getCategoryFromCacheOrRemote(false).then((value) {
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
  Widget build(context) {
    return ResponsivePage(
      current: '/stock/',
      sliverAppBar: _appBar(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      staticChildren: [
        getTableContextMenu(_contextItems(context)),
        _loading(_isLoading),
        // _tableHeader(),
      ],
      dynamicChildBuilder: (context, index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              onTap: () => _onManageCategory(index),
              contentPadding: EdgeInsets.zero,
              title: BodyLarge(text:
                  firstLetterUpperCase('${_categories[index]['name']}')),
              subtitle: _categories[index]['description'] != '' && _categories[index]['description'] != 'null' && !getIsSmallScreen(context)
                  ? LabelLarge(text: firstLetterUpperCase('${_categories[index]['description']}'))
                  : null,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    '${_categories[index]['image']}',
                    errorBuilder: (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LabelLarge(
                    text: 'Manage',
                    color: Theme.of(context).primaryColor,
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            const SizedBox(height: 8),
            const HorizontalLine(),
            const SizedBox(height: 16),
          ],
        );
      },
      fab: FloatingActionButton(
        onPressed: () => _showMobileContextMenu(context),
        child: const Icon(Icons.unfold_more_outlined),
      ),
      totalDynamicChildren: _categories.length,
    );
  }

  _onDelete(index) {
    showDialogDelete(
      onDone: (p0) {
        Navigator.of(context).maybePop();
      },
      context: context,
      name: firstLetterUpperCase('${_categories[index]['name']}'),
      onDelete: () {
        return _deleteCategory('${_categories[index]['id']}');
      },
    );
  }

  _fetchCategories() {
    setState(() {
      _isLoading = true;
    });
    getCategoryFromCacheOrRemote(true).then(
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
                title: const BodyLarge(text: 'Create'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _createCategory());
                },
              ),
              const HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload'),
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
    showDialogOrFullScreenModal(
      CreateCategoryContent(onNewCategory: (category) {
        _fetchCategories();
      }),
      context,
    );
  }

  Future _deleteCategory(id) async {
    var shop = await getActiveShop();
    var deleteCategory = prepareDeleteCategoryAPI(id);
    await deleteCategory(shop);
    _fetchCategories();
  }

  void _onManageCategory(index) {
    showDialogOrModalSheet(
        Container(
          padding: const EdgeInsets.all(16),
          constraints: getIsSmallScreen(context)
              ? null
              : const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BodyLarge(text: 'Manage category " ${_categories[index]?['name']??''} "'),
              const WhiteSpacer(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    _onEditCategory(index);
                  });
                },
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const BodyLarge(text: 'Edit category'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.of(context).maybePop().whenComplete(() {
                    _onDelete(index);
                  });
                },
                leading: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const BodyLarge(text: 'Delete category'),
              )
            ],
          ),
        ),
        context);
  }

  void _onEditCategory(index) {
    showDialogOrFullScreenModal(
      CreateCategoryContent(
          category: _categories[index],
          onNewCategory: (category) {
            _fetchCategories();
          }),
      context,
    );
  }
}
