import 'package:flutter/cupertino.dart';
import 'package:smartstock/core/components/ResponsivePage.dart';
import 'package:smartstock/core/components/stock_app_bar.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_expense_content.dart';

class ExpenseCreatePage extends StatefulWidget {
  final OnBackPage onBackPage;

  const ExpenseCreatePage({
    Key? key,
    required this.onBackPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ExpenseCreatePage> {
  @override
  Widget build(BuildContext context) {
    return ResponsivePage(
      sliverAppBar: getSliverSmartStockAppBar(
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
