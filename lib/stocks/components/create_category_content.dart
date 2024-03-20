import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/TitleLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/stocks/services/api_categories.dart';
import 'package:smartstock/stocks/services/category.dart';

class CreateCategoryContent extends StatefulWidget {
  final dynamic Function(Map category) onNewCategory;
  final Map? category;

  const CreateCategoryContent(
      {super.key, required this.onNewCategory, this.category});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateCategoryContent> {
  String _name = '';
  String _description = '';
  var _err = {};
  var _createProgress = false;
  List<FileData?> _platformFiles = [];

  @override
  void initState() {
    if (widget.category is Map) {
      _updateState(() {
        _name = widget.category!['name'];
        _description = widget.category!['description'];
        _platformFiles = _getInitialFileData(widget.category!);
      });
    }
    super.initState();
  }

  _updateState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var form = ListView(
      shrinkWrap: true,
      children: [
        const TitleLarge(text: 'Category'),
        TextInput(
            initialText: _name,
            onText: (d) {
              _updateState(() {
                _name = d;
                _err['name'] = '';
              });
            },
            label: "Name",
            error: _err['name'] ?? ''),
        const WhiteSpacer(height: 16),
        TextInput(
            initialText: _description,
            onText: (d) {
              _updateState(() {
                _description = d;
              });
            },
            label: "Description",
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
    return Container(
      padding: const EdgeInsets.all(16),
      width: isSmallScreen ? null : 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          isSmallScreen ? Expanded(child: form) : form,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: CancelProcessButtonsRow(
              cancelText: 'Cancel',
              onCancel: () => Navigator.of(context).maybePop(),
              proceedText: _createProgress
                  ? "Waiting..."
                  : doubleOrZero(widget.category?['id']) > 0
                      ? "Update"
                      : "Create",
              onProceed: _createProgress ? null : _createCategory,
            ),
          ),
        ],
      ),
    );
  }

  // updateState(Map<String, String> map) {
  //   _category.addAll(map);
  // }

  List<FileData?> _getInitialFileData(Map category) {
    return justArray(category['image']).map((x) {
      String name = x.split('/').last;
      String ext = name.split('.').last;
      return FileData(
          stream: null, extension: ext, size: -1, name: name, path: x);
    }).toList();
  }

  bool _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      _err['name'] = 'Name required';
      return x;
    });
    _updateState(() => {});
    return isString(_name.trim().isNotEmpty);
  }

  _createCategory() async {
    var shop = await getActiveShop();
    if (_validateName()) {
      _updateState(() {
        _err = {};
        _createProgress = true;
      });
      uploadFileToWeb3(_platformFiles).then((fileResponse) {
        if (kDebugMode) {
          print(fileResponse);
        }
        var id = doubleOrZero(widget.category?['id']);
        var category = {
          'name': _name,
          'description': _description,
          'image': fileResponse.map((e) => e['link']).join(',')
        };
        var updateCategory = prepareUpdateCategoryAPI(id, category);
        var createCategory = prepareUpsertCategoryAPI(category);
        return id > 0 ? updateCategory(shop) : createCategory(shop);
      }).then((value) {
        if (kDebugMode) {
          print(value);
        }
        widget.onNewCategory({
          'name': _name,
          'description': _description,
          ...itOrEmptyArray(value)[0] ?? {}
        });
        getCategoryFromCacheOrRemote(true)
            .then((value) => null)
            .catchError((error) {})
            .whenComplete(() {
          Navigator.of(context).maybePop();
        });
      }).catchError((err) {
        showTransactionCompleteDialog(context, err, canDismiss: true);
      }).whenComplete(() {
        _updateState(() {
          _createProgress = false;
        });
      });
    }
  }
}
