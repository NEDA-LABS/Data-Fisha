import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/sliver_smartstock_appbar.dart';
import 'package:smartstock/core/pages/page_base.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_expense_content.dart';

class ExpenseCreatePage extends PageBase {
  final OnBackPage onBackPage;

  const ExpenseCreatePage({
    Key? key,
    required this.onBackPage,
  }) : super(key: key, pageName: 'ExpenseCreatePage');

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseCreatePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      sliverAppBar: SliverSmartStockAppBar(
        title: 'Create expense',
        context: context,
        showBack: true,
        onBack: widget.onBackPage,
      ),
      staticChildren: [
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CreateExpenseContent(onBackPage: widget.onBackPage),
          ),
        ),
      ],
    );
  }
}
