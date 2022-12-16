import 'package:flutter/material.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_item_content.dart';
import 'package:smartstock/expense/services/expenses.dart';
import 'package:smartstock/expense/services/items.dart';

class CreateExpenseContent extends StatefulWidget {
  const CreateExpenseContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateExpenseContent> {
  Map state = {
    "item": "",
    "item_err": "",
    "amount": "",
    "amount_err": "",
    "req_err": "",
    "creating": false
  };
  Map _categories = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            ChoicesInput(
              label: "Item",
              placeholder: "Choose item",
              onText: (d) => _updateState({'item': d, 'item_err': ''}),
              onLoad: getExpenseItemFromCacheOrRemote,
              onField: (p0){
                _categories[p0['name']] = p0['category'];
                return p0['name'];
              },
              getAddWidget: () => const CreateExpenseItemContent(),
            ),
            TextInput(
              onText: (d) => _updateState({'amount': d, 'amount_err': ''}),
              label: "Amount",
              error: state['amount_err'] ?? '',
              type: TextInputType.number,
            ),
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
                              : "Save expense.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(state['req_err'])
          ],
        ),
      ),
    );
  }

  _updateState(map) {
    if (map is Map) {
      setState(() {
        state.addAll(map);
      });
    }
  }

  _onPressed() {
    _updateState({'req_err': ''});
    var item = state['item']??'';
    var amount = doubleOrZero(state['amount']);
    if (item.isEmpty) {
      _updateState({'item_err': 'Item required'});
      return;
    }
    if (amount<=0) {
      _updateState({'amount_err': 'Amount must be greater than zero'});
      return;
    }
    _updateState({'creating': true});
    submitExpenses(
            name: item,
            category: _categories[item],
            amount: amount)
        .catchError((err) {
          _updateState({'req_err': '$err'});
        })
        .then((value) => Navigator.of(context).maybePop())
        .whenComplete(() => _updateState({'creating': false}));
  }
}
