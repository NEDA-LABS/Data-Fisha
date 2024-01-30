import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/file_data.dart';

// Future addPurchaseDetail({
//   required BuildContext context,
//   required onSubmit,
// }) =>
//     showDialog(
//       context: context,
//       builder: (c) {
//         return Dialog(child: AddPurchaseDetailDialog(onSubmit: onSubmit));
//       },
//     );

class AddPurchaseDetailContent extends StatefulWidget {
  final Function(Map states,List<FileData?> files) onSubmit;

  const AddPurchaseDetailContent({super.key, required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AddPurchaseDetailContent> {
  Map states = {"reference": '', "type": 'receipt', 'date': '', 'due': ''};
  List<FileData?> _files = [];

  _prepareUpdateState() => ifDoElse(
      (x) => x is Map, (x) => setState(() => states.addAll(x)), (x) => null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _addToCartBoxDecoration(),
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CheckboxListTile(
                title: const Text("Is this invoice purchased?"),
                value: states['type'] == 'invoice',
                onChanged: (b) => b!
                    ? _prepareUpdateState()({'type': 'invoice'})
                    : _prepareUpdateState()({'type': 'receipt'})),
          ),
          TextInput(
              label: 'Purchase reference',
              initialText: '${states['reference'] ?? ''}',
              lines: 1,
              error: states['error_r'] ?? '',
              type: TextInputType.text,
              onText: (v) => _prepareUpdateState()({'reference': v,'error_r':''})),
          DateInput(
            label: 'Purchase date',
            onText: (d) => _prepareUpdateState()({'date': d,'error_d':''}),
            error: states['error_d'],
            firstDate: DateTime.now().subtract(const Duration(days: 360)),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
          ),
          states['type'] == 'invoice'
              ? DateInput(
                  label: 'Payment due date',
                  onText: (d) => _prepareUpdateState()({'due': d}),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 360)),
                  initialDate: DateTime.now(),
                )
              : Container(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: LabelLarge(text: 'Purchase receipt'),
          ),
          FileSelect(onFiles: (file) {
            _files = file;
          },),
          _addToCartButton(),
        ],
      ),
    );
  }

  _addToCartButton(){
    return  Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
            onPressed: () {
              _prepareUpdateState()({'error_r': '', 'error_d': ''});
              if ('${states['reference'] ?? ''}'.isEmpty) {
                _prepareUpdateState()({'error_r': 'Reference required'});
              }
              if ('${states['date'] ?? ''}'.isEmpty) {
                _prepareUpdateState()({'error_d': 'Purchase date required'});
                return;
              }
              widget.onSubmit(states,_files);
            },
            style: _addToCartButtonStyle(context),
            child: const Text("SUBMIT", style: TextStyle(color: Colors.white))));
  }

  _addToCartButtonStyle(context) => ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColorDark));

  _addToCartBoxDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );
}
