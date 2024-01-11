import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/choices_input.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/expense/components/create_category_content.dart';
import 'package:smartstock/expense/services/categories.dart';
import 'package:smartstock/expense/services/expenses.dart';

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
    "date": "",
    "item_err": "",
    "category": "",
    "category_err": "",
    "amount": "",
    "amount_err": "",
    "req_err": "",
    "creating": false
  };
  List<FileData?> _platformFile = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            DateInput(
                onText: (d) => _updateState({'date': d, 'date_err': ''}),
                label: 'Date',
                error: state['date_err'],
                firstDate:
                    DateTime.now().subtract(const Duration(days: 360 * 2)),
                initialDate: DateTime.now(),
                lastDate: DateTime.now()),
            TextInput(
              label: "Item name",
              placeholder: "",
              error: state['name_err'] ?? '',
              onText: (d) => _updateState({'name': d, 'name_err': ''}),
            ),
            ChoicesInput(
              choice: state['category'],
              label: "Category",
              placeholder: "Click to select",
              error: state['category_err'] ?? '',
              onChoice: (d) => _updateState({'category': d, 'category_err': ''}),
              onLoad: getExpenseCategoriesFromCacheOrRemote,
              onField: (p0) {
                // _categories[p0['name']] = p0['category'];
                return p0['name'];
              },
              getAddWidget: () => const CreateExpenseCategoryContent(),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: LabelLarge(text: 'Receipt'),
            ),
            // Container(
            //   height: 48,
            //   margin: const EdgeInsets.only(bottom: 16),
            //   child: OutlinedButton(
            //       onPressed: _onUploadReceipt,
            //       child: BodyLarge(
            //           text:
            //               'Select${_platformFile != null ? 'ed' : ''} file [ ${_platformFile?.name ?? ''} ]')),
            // ),
            FileSelect(
              onFile: (file) {
                if (mounted) {
                  _platformFile = file;
                }
              },
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
    var date = '${state['date'] ?? ''}';
    var category = '${state['category'] ?? ''}';
    var amount = doubleOrZero(state['amount']);
    if (name.isEmpty) {
      _updateState({'name_err': 'Item name required'});
    }
    if (date.isEmpty) {
      _updateState({'date_err': 'Date required'});
    }
    if (category.isEmpty) {
      _updateState({'category_err': 'Item category required'});
    }
    if (amount <= 0) {
      _updateState({'amount_err': 'Amount must be greater than zero'});
      return;
    }
    if (kDebugMode) {
      print('Everything cool, expenses');
    }
    _updateState({'creating': true});
    uploadFileToWeb3(_platformFile)
        .then((fileResponse) {
          return submitExpenses(
              name: name,
              date: date,
              category: category,
              amount: amount,
              file: fileResponse.map((e) => {
                "name": e['name'],
                "size": e['size'],
                "mime": e['mime'],
                "link": e['link'],
                "cid": e['cid'],
                "tags": 'receipt,expense,expenses',
              }).toList());
        })
        .catchError((e) => showInfoDialog(context, e))
        .then((value) => showInfoDialog(context, 'Expense created successful'))
        .then((value) => widget.onBackPage())
        .whenComplete(() => _updateState({'creating': false}));
  }
}
