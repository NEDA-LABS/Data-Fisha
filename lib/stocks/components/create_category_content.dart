import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(
          children: [
            TextInput(
                onText: (d) => updateState({'name': d}),
                label: "Name",
                error: err['name'] ?? ''),
            TextInput(
                onText: (d) => updateState({'description': d}),
                label: "Description",
                lines: 3,
                placeholder: 'Optional'),
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
                                  createProgress ? null : () => create(context),
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

  _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      err['name'] = 'Name required';
      return x;
    });
    return isString(
        category['name'] is String && '${category['name']}'.isNotEmpty);
  }

  _validCategory() => and([_validateName]);

  create(context) async {
    setState(() {
      err = {};
      requestError = '';
      createProgress = true;
    });
    var shop = await getActiveShop();
    var createIFValid = ifDoElse(
      (_) => _validCategory(),
      createCategory({...category, 'id': '${category['name']}'.toLowerCase()}),
      (_) async => 'nope',
    );
    createIFValid(shop).then((r) {
      if (r == 'nope') return;
      // var productFormState = getState<ProductCreateState>();
      // productFormState.product['category'] = category['name'];
      // productFormState.refresh();
      Navigator.of(context).maybePop();
    }).catchError((err) {
      requestError = '$err, Please try again';
    }).whenComplete(() {
      setState(() {
        createProgress = false;
      });
    });
  }
}
