import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/file_select.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/stocks/services/api_categories.dart';

class CreateCategoryContent extends StatefulWidget {
  const CreateCategoryContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateCategoryContent> {
  var category = {};
  var err = {};
  var createProgress = false;
  var requestError = '';
  FileData? _platformFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            TextInput(
                onText: (d) => updateState({'name':(d??'').toLowerCase().trim()}),
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
              onFile: (file) {
                _platformFile = file;
              },
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
                              onPressed: createProgress
                                  ? null
                                  : () => _createCategory(context),
                              child: Text(
                                  createProgress
                                      ? "Waiting..."
                                      : "Create category.",
                                  style: const TextStyle(fontSize: 16)))))
                ],
              ),
            ),
            Text(requestError)
          ],
        ),
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
    return isString(
        category['name'] is String && '${category['name']}'.isNotEmpty);
  }

  _createCategory(context) async {
    setState(() {
      err = {};
      requestError = '';
      createProgress = true;
    });
    var shop = await getActiveShop();
    if (_validateName()) {
      uploadFileToWeb3(_platformFile).then((fileResponse) {
        if (kDebugMode) {
          print(fileResponse);
        }
        var createCategory = prepareUpsertCategoryAPI({
          ...category,
          'image': fileResponse?['link'] ?? "",
          'file': fileResponse is Map
              ? {
                  "name": fileResponse['name'],
                  "size": fileResponse['size'],
                  "mime": fileResponse['mime'],
                  "link": fileResponse['link'],
                  "cid": fileResponse['cid'],
                  "tags": 'receipt,expense,expenses',
                }
              : null
        });
        return createCategory(shop);
      }).then((value) {
        Navigator.of(context).maybePop();
      }).catchError((err) {
        // requestError = '$err, Please try again';
        showInfoDialog(context, err);
      }).whenComplete(() {
        setState(() {
          createProgress = false;
        });
      });
    }
  }
}
