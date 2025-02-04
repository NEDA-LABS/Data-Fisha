import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/helpers/dialog_or_bottom_sheet.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/components/create_category_content.dart';
import 'package:smartstock/stocks/services/category.dart';

class CategoryCreatePage extends PageBase {
  final OnBackPage onBackPage;

  const CategoryCreatePage({
    super.key,
    required this.onBackPage,
  }) : super(pageName: 'CategoryCreatePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CategoryCreatePage> {
  bool _isLoading = false;
  List _categories = [];

  _appBar(context) {
    return SliverSmartStockAppBar(
      title: "Create category",
      showBack: true,
      showSearch: false,
      onBack: widget.onBackPage,
      context: context,
    );
  }

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
        staticChildren: [CreateCategoryContent(onNewCategory: (category) {})],
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
                title: const BodyLarge(text: 'Create category'),
                onTap: () {
                  Navigator.of(context)
                      .maybePop()
                      .whenComplete(() => _createCategory());
                },
              ),
              HorizontalLine(),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const BodyLarge(text: 'Reload categories'),
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
          child: Dialog(
            child: CreateCategoryContent(
              onNewCategory: (category) {},
            ),
          ),
        ),
      ),
    );
  }
}
