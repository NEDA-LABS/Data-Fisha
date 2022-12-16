import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/expense/services/categories.dart';

class CreateExpenseCategoryContent extends StatefulWidget {
  const CreateExpenseCategoryContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateExpenseCategoryContent> {
  Map state = {"name": "", "name_err": "", "req_err": "", "creating": false};

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
                              : "Create category.",
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
    if ((state['name'] ?? '').isEmpty) {
      _updateState({'name_err': 'Name required'});
      return;
    }
    _updateState({'creating': true});
    createExpenseCategory(state['name'])
        .catchError((err) {
          _updateState({'req_err': '$err'});
        })
        .then((value) => Navigator.of(context).maybePop())
        .whenComplete(() => _updateState({'creating': true}));
  }
}
