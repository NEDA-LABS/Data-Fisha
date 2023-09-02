import 'package:bfast/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/date_input.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/text_input.dart';

import '../../core/components/BodyLarge.dart';

Future addPurchaseDetail({
  required BuildContext context,
  required onSubmit,
}) =>
    showDialog(
      context: context,
      builder: (c) {
        return Dialog(child: _AddPurchaseDetailDialog(onSubmit: onSubmit));
      },
    );

class _AddPurchaseDetailDialog extends StatefulWidget {
  final onSubmit;

  const _AddPurchaseDetailDialog({required this.onSubmit, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<_AddPurchaseDetailDialog> {
  Map states = {"reference": '', "type": 'receipt', 'date': '', 'due': ''};
  PlatformFile? _platformFile;

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
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 16),
            child: OutlinedButton(
                onPressed: _onUploadReceipt,
                child: BodyLarge(
                    text:
                        'Select${_platformFile != null ? 'ed' : ''} file [ ${_platformFile?.name ?? ''} ]')),
          ),
          _addToCartButton(
              context, states, _prepareUpdateState(), widget.onSubmit),
        ],
      ),
    );
  }

  _addToCartButton(context, states, updateState, onSubmit) => Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
          onPressed: () {
            updateState({'error_r': '', 'error_d': ''});
            if ('${states['reference'] ?? ''}'.isEmpty) {
              updateState({'error_r': 'Reference required'});
            }
            if ('${states['date'] ?? ''}'.isEmpty) {
              updateState({'error_d': 'Purchase date required'});
              return;
            }
            onSubmit(states,_platformFile);
          },
          style: _addToCartButtonStyle(context),
          child: const Text("SUBMIT", style: TextStyle(color: Colors.white))));

  _addToCartButtonStyle(context) => ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColorDark));

  _addToCartBoxDecoration() => const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );

  void _onUploadReceipt() {
    handleFile(value) {
      FilePickerResult? result = value;
      if (mounted) {
        if (result != null) {
          setState(() {
            _platformFile = result.files.single;
          });
        } else {
          showInfoDialog(context, "Fail to get selected file");
        }
      }
    }

    handleError(error) {
      if (mounted) {
        showInfoDialog(context, error);
      }
    }

    FilePicker.platform
        .pickFiles(
            allowMultiple: false,
            lockParentWindow: true,
            withReadStream: true,
            withData: false)
        .then(handleFile)
        .catchError(handleError);
  }
}
