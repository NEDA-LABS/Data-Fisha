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

  const CreateCategoryContent({super.key, required this.onNewCategory});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateCategoryContent> {
  var category = {};
  var err = {};
  var createProgress = false;
  List<FileData?> _platformFiles = [];

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = getIsSmallScreen(context);
    var form = ListView(
      shrinkWrap: true,
      children: [
        const TitleLarge(text: 'Category'),
        TextInput(
            onText: (d) => updateState({'name': d.toLowerCase().trim()}),
            label: "Name",
            error: err['name'] ?? ''),
        const WhiteSpacer(height: 16),
        TextInput(
            onText: (d) => updateState({'description': d}),
            label: "Description",
            lines: 3,
            placeholder: 'Optional'),
        const WhiteSpacer(height: 16),
        FileSelect(
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
              proceedText: createProgress ? "Waiting..." : "Create category",
              onProceed: createProgress ? null : () => _createCategory(context),
            ),
          ),
        ],
      ),
    );
  }

  updateState(Map<String, String> map) {
    category.addAll(map);
  }

  bool _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      err['name'] = 'Name required';
      return x;
    });
    setState(() => {});
    return isString(
        category['name'] is String && '${category['name']}'.isNotEmpty);
  }

  _createCategory(context) async {
    var shop = await getActiveShop();
    if (_validateName()) {
      setState(() {
        err = {};
        createProgress = true;
      });
      uploadFileToWeb3(_platformFiles).then((fileResponse) {
        if (kDebugMode) {
          print(fileResponse);
        }
        var createCategory = prepareUpsertCategoryAPI({
          ...category,
          'image': fileResponse.map((e) => e['link']).join(','),
          'file': fileResponse
              .map((e) => {
                    "link": e['link'],
                    "tags": 'receipt,expense,expenses',
                  })
              .toList()
        });
        return createCategory(shop);
      }).then((value) {
        if (kDebugMode) {
          print(value);
        }
        widget.onNewCategory({...category, ...itOrEmptyArray(value)[0] ?? {}});
        getCategoryFromCacheOrRemote(true)
            .then((value) => null)
            .catchError((error) {})
            .whenComplete(() {
          Navigator.of(context).maybePop();
        });
      }).catchError((err) {
        showTransactionCompleteDialog(context, err,canDismiss: true);
      }).whenComplete(() {
        setState(() {
          createProgress = false;
        });
      });
    }
  }
}
