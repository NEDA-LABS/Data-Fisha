import 'package:flutter/material.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/components/table_context_menu.dart';
import 'package:smartstock/core/components/table_like_list_data_cell.dart';
import 'package:smartstock/core/components/table_like_list_row.dart';
import 'package:smartstock/core/components/table_like_list_header_cell.dart';
import 'package:smartstock/core/models/menu.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/expense/components/create_category_content.dart';
import 'package:smartstock/expense/services/categories.dart';

class ExpenseCategoriesPage extends PageBase {
  final OnBackPage onBackPage;

  const ExpenseCategoriesPage({
    Key? key,
    required this.onBackPage,
  }) : super(key: key,pageName: 'ExpenseCategoriesPage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseCategoriesPage> {
  String _query = '';
  bool _isLoading = false;
  List _categories = [];

  @override
  void initState() {
    _fetchCategories(false);
    super.initState();
  }

  @override
  Widget build(context) {
    return ResponsivePage(
      current: '/expense/',
      sliverAppBar: SliverSmartStockAppBar(
        title: 'Expense categories',
        onBack: widget.onBackPage,
        showBack: true,
        context: context,
      ),
      staticChildren: [
        getTableContextMenu(_contextItems(context)),
        _loading(_isLoading),
        _tableHeader(),
      ],
      dynamicChildBuilder: (context, index) {
        return TableLikeListRow([
          TableLikeListHeaderCell(_categories[index]['name'] ?? ''),
        ]);
      },
      totalDynamicChildren: _categories.length,
      // onBody: (d) => Scaffold(
      //   body: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       Expanded(
      //         child: TableLikeList(
      //           onFuture: () async => _categories, keys: _fields(),
      //           // onItemPressed: _showOption,
      //           // onCell: (key,data)=>Text('@$data')
      //         ),
      //       ),
      //       // _tableFooter()
      //     ],
      //   ),
      // ),
    );
  }

  _contextItems(context) {
    return [
      ContextMenu(
        name: 'Add',
        pressed: () {
          showDialog(
            context: context,
            builder: (c) => Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: const Dialog(
                  child: CreateExpenseCategoryContent(),
                ),
              ),
            ),
          ).whenComplete(() => _fetchCategories(true));
        },
      ),
      ContextMenu(
        name: 'Reload',
        pressed: () {
          _fetchCategories(true);
        },
      ),
    ];
  }

  _tableHeader() =>
      const TableLikeListRow([TableLikeListHeaderCell('Name')]);

  _fields() => ['name'];

  _loading(bool show) =>
      show ? const LinearProgressIndicator(minHeight: 4) : Container();

  void _fetchCategories(bool remote) {
    setState(() {
      _isLoading = true;
    });
    getExpenseCategoriesFromCacheOrRemote(skipLocal: remote, stringLike: _query)
        .then((value) {
      _categories = value;
    }).catchError((err) {
      showInfoDialog(context, '$err', title: 'Error');
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

// _showOption(element) {
//   showDialogOrModalSheet(Container(
//     constraints: BoxConstraints(
//       maxWidth: 500
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Text("Options"),
//         ),
//         TextButton(onPressed: () {
//
//         }, child: Text("Delete"))
//       ],
//     ),
//   ), context);
// }
}
