import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/api_suppliers.dart';

class CreateSupplierContent extends StatefulWidget {
  final VoidCallback onDone;
  final Map? supplier;

  const CreateSupplierContent({super.key, required this.onDone, this.supplier});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateSupplierContent> {
  var _name = '';
  var _number = '';
  var _address = ' ';
  var _errors = {};
  var _createProgress = false;
  List<FileData?> _platformFiles = [];

  @override
  void initState() {
    if (widget.supplier is Map) {
      _updateState(() {
        _name = widget.supplier!['name'];
        _number = widget.supplier!['number'];
        _address = widget.supplier!['address'];
        _platformFiles = _getInitialFileData(widget.supplier!);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var form = ListView(
      shrinkWrap: true,
      children: [
        TextInput(
          initialText: _name,
          onText: (d) {
            _updateState(() {
              _name = d;
              _errors = {..._errors, 'name': ''};
            });
          },
          label: "Name",
          error: '${_errors['name'] ?? ''}',
        ),
        TextInput(
          initialText: _number,
          onText: (d) {
            _updateState(() {
              _number = d;
              _errors = {..._errors, 'number': ''};
            });
          },
          label: "Mobile",
          error: '${_errors['number'] ?? ''}',
          // placeholder: 'Optional',
        ),
        // TextInput(
        //     onText: (d) => updateState({'email': d}),
        //     label: "Email",
        //     placeholder: 'Optional'),
        TextInput(
          initialText: _address,
            onText: (d) {
              _updateState(() {
                _address = d;
                // _errors = {..._errors,'address':''};
              });
            },
            label: "Address",
            lines: 3,
            placeholder: 'Optional'),
        const WhiteSpacer(height: 16),
        FileSelect(
          files: _platformFiles,
          onFiles: (file) {
            _platformFiles = file;
          },
        ),
      ],
    );
    var isSmallScreen = getIsSmallScreen(context);
    return Container(
      padding: const EdgeInsets.all(16),
      width: isSmallScreen ? null : 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isSmallScreen ? Expanded(child: form) : form,
          const WhiteSpacer(height: 16),
          CancelProcessButtonsRow(
            cancelText: 'Cancel',
            onCancel: () {
              Navigator.of(context).maybePop();
            },
            proceedText: _createProgress
                ? "Waiting..."
                : doubleOrZero(widget.supplier?['id']) > 0
                    ? "Update"
                    : "Create",
            onProceed: _createProgress ? null : _submit,
          )
        ],
      ),
    );
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      _errors['name'] = 'Name required';
      return x;
    });
    return isString(_name.isNotEmpty);
  }

  _validateMobile() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      _errors['number'] = 'Mobile number required';
      return x;
    });
    return isString(_number.isNotEmpty);
  }

  _validSupplier() {
    var hasNoError = true;
    if (!_validateName()) {
      hasNoError = false;
    }
    if (!_validateMobile()) {
      hasNoError = false;
    }
    _updateState(() {});
    return hasNoError;
  }

  _submit() async {
    _updateState(() {
      _errors = {};
      _createProgress = true;
    });
    var shop = await getActiveShop();
    // var supplier = {
    //   'name': _name,
    //   'number': _number,
    //   'address': _address,
    //   'id': _name.toLowerCase()
    // };
    var id = doubleOrZero(widget.supplier?['id'] ?? '0');
    var createIFValid = ifDoElse(
      (_) => _validSupplier(),
      (_) => productCreateSupplierRestAPI({
        'name': _name,
        'number': _number,
        'address': _address,
        'id': _name.toLowerCase(),
        'image': justArray(_).map((e) => e['link']).join(',')
      }, shop),
      (_) async => 'nope',
    );
    var updateIFValid = ifDoElse(
      (_) => _validSupplier(),
      (_) => prepareUpdateSupplierAPI(id, {
        'name': _name,
        'mobile': _number,
        'address': _address,
        'image': justArray(_).map((e) => e['link']).join(',')
      })(shop),
      (_) async => 'nope',
    );
    uploadFileToWeb3(_platformFiles).then((fileResponse) {
      return (id > 0 ? updateIFValid(fileResponse) : createIFValid(fileResponse));
    }).then((r) {
      if (r == 'nope') return;
      widget.onDone();
      showTransactionCompleteDialog(context, 'Picker created successful',
              canDismiss: true)
          .whenComplete(() {
        Navigator.of(context).maybePop();
      });
    }).catchError((err) {
      showTransactionCompleteDialog(context, '$err, Please try again',
          canDismiss: true);
    }).whenComplete(() {
      _updateState(() {
        _createProgress = false;
      });
    });
  }

  List<FileData?> _getInitialFileData(Map category) {
    return justArray(category['image']).where((t) => '$t'.toLowerCase()!='null').map((x) {
      String name = '$x'.split('/').last;
      String ext = name.split('.').last;
      return FileData(
          stream: null, extension: ext, size: -1, name: name, path: x);
    }).toList();
  }
}
