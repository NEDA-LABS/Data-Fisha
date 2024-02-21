import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/expense/components/create_category_content.dart';
import 'package:smartstock/expense/services/categories.dart';
import 'package:smartstock/expense/services/items.dart';

class CreateExpenseItemContent extends StatefulWidget {
  const CreateExpenseItemContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateExpenseItemContent> {
  Map state = {
    "name": "",
    "name_err": "",
    "category": "",
    "category_err": "",
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
              onText: (d) => _updateState({'name': d, 'name_err': ''}),
              label: "Name",
              error: state['name_err'] ?? '',
            ),
            ChoicesInput(
              choice: state['category'],
              label: "Category",
              placeholder: "Choose category",
              onChoice: (d) => _updateState({'category': d, 'category_err': ''}),
              onLoad: getExpenseCategoriesFromCacheOrRemote,
              onField: (p0) => p0 is Map? p0["name"]: p0??'',
              getAddWidget: () => const CreateExpenseCategoryContent(),
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
                        child: BodyLarge(
                          text: state['creating'] == true
                              ? "Waiting..."
                              : "Create item.",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            BodyLarge(text: state['req_err'])
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
    if ((state['name'] ?? '').isEmpty) {
      _updateState({'name_err': 'Name required'});
      return;
    }
    if ((state['category'] ?? '').isEmpty) {
      _updateState({'category_err': 'Category required'});
      return;
    }
    _updateState({'creating': true});
    createExpenseItem(state['name'], state['category'])
        .catchError((err) {
          _updateState({'req_err': '$err'});
        })
        .then((value) => Navigator.of(context).maybePop())
        .whenComplete(() => _updateState({'creating': true}));
  }
}
