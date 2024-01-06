import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_suppliers.dart';

class CreateSupplierContent extends StatefulWidget {
  const CreateSupplierContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateSupplierContent> {
  var supplier = {};
  var err = {};
  var createProgress = false;
  var requestError = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ListBody(children: [
          TextInput(
            onText: (d) => updateState({'name': d}),
            label: "Name",
            error: err['name'] ?? '',
          ),
          TextInput(
            onText: (d) => updateState({'number': d}),
            label: "Mobile",
            placeholder: 'Optional',
          ),
          TextInput(
              onText: (d) => updateState({'email': d}),
              label: "Email",
              placeholder: 'Optional'),
          TextInput(
              onText: (d) => updateState({'address': d}),
              label: "Address",
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
                      onPressed: createProgress ? null : () => create(context),
                      child: Text(
                        createProgress ? "Waiting..." : "Create supplier.",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(requestError)
        ]),
      ),
    );
  }

  updateState(Map<String, String> map) {
    supplier.addAll(map);
  }

  _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      err['name'] = 'Name required';
      return x;
    });
    return isString(
        supplier['name'] is String && '${supplier['name']}'.isNotEmpty);
  }

  _validSupplier() => and([_validateName]);

  create(context) async {
    setState(() {
      err = {};
      requestError = '';
      createProgress = true;
    });
    var shop = await getActiveShop();
    var createIFValid = ifDoElse(
      (_) => _validSupplier(),
      createSupplier({...supplier, 'id': '${supplier['name']}'.toLowerCase()}),
      (_) async => 'nope',
    );
    createIFValid(shop).then((r) {
      if (r == 'nope') return;
      // var productFormState = getState<ProductCreateState>();
      // productFormState.product['supplier'] = supplier['name'];
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
