import 'package:flutter/material.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_category_content.dart';
import 'package:smartstock/expense/components/create_item_content.dart';
import 'package:smartstock/expense/services/categories.dart';
import 'package:smartstock/expense/services/expenses.dart';
import 'package:smartstock/expense/services/items.dart';

class CreateExpenseContent extends StatefulWidget {
  final OnBackPage onBackPage;

  const CreateExpenseContent({Key? key, required this.onBackPage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateExpenseContent> {
  Map state = {
    "item": "",
    "item_err": "",
    "category": "",
    "category_err": "",
    "amount": "",
    "amount_err": "",
    "req_err": "",
    "creating": false
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            TextInput(
              label: "Item name",
              placeholder: "",
              error: state['name_err'] ?? '',
              onText: (d) => _updateState({'name': d, 'name_err': ''}),
            ),
            ChoicesInput(
              label: "Category",
              placeholder: "Click to select",
              error: state['category_err'] ?? '',
              onText: (d) => _updateState({'category': d, 'category_err': ''}),
              onLoad: getExpenseCategoriesFromCacheOrRemote,
              onField: (p0) {
                // _categories[p0['name']] = p0['category'];
                return p0['name'];
              },
              getAddWidget: () => const CreateExpenseCategoryContent(),
            ),
            TextInput(
              onText: (d) => _updateState({'amount': d, 'amount_err': ''}),
              label: "Amount",
              error: state['amount_err'] ?? '',
              type: TextInputType.number,
            ),
            const WhiteSpacer(height: 16),
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed:
                            state['creating'] == true ? null : _onPressed,
                        child: Text(
                          state['creating'] == true
                              ? "Waiting..."
                              : "Save expense",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Text(state['req_err'])
          ],
        ),
      ),
    );
  }

  _updateState(map) {
    if (map is Map) {
      if (mounted) {
        setState(() {
          state.addAll(map);
        });
      }
    }
  }

  _onPressed() {
    // _updateState({'req_err': ''});
    var name = '${state['name'] ?? ''}';
    var category = '${state['category'] ?? ''}';
    var amount = doubleOrZero(state['amount']);
    if (name.isEmpty) {
      _updateState({'name_err': 'Item name required'});
      return;
    }
    if (category.isEmpty) {
      _updateState({'category_err': 'Item category required'});
      return;
    }
    if (amount <= 0) {
      _updateState({'amount_err': 'Amount must be greater than zero'});
      return;
    }
    print('Everything cool, expenses');
    _updateState({'creating': true});
    submitExpenses(
      name: name,
      category: category,
      amount: amount,
    )
        .catchError((e) => showInfoDialog(context, e))
        .then((value) => showInfoDialog(context, 'Expense created successful'))
        .then((value) => widget.onBackPage())
        .whenComplete(() => _updateState({'creating': false}));
  }
}
