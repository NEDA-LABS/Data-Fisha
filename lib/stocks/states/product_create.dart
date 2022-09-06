import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_stock.dart';

class ProductCreateState extends ChangeNotifier {
  Map<String, dynamic> product = {};
  Map<String, dynamic> error = {};
  var loading = false;

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => notifyListeners();

  _fieldIsValidString(field) => ifDoElse(
          (x) => product[x] is String && product[x].isNotEmpty, (x) => true,
          (x) {
        error[x] = 'Required';
        return false;
      })(field);

  _fieldIsValidNumber(field) => ifDoElse(
          (x) =>
              int.parse(
                      '${product[x] ?? ''}'.isNotEmpty ? '${product[x]}' : '0')
                  is int &&
              int.parse('${product[x] ?? ''}'.isNotEmpty
                      ? '${product[x]}'
                      : '0') >=
                  0,
          (x) => true, (x) {
        error[x] = 'Required, and must be greater than zero';
        return false;
      })(field);

  create(context) {
    error = {};
    loading = true;
    notifyListeners();
    var invalids = [
      _fieldIsValidString('product'),
      _fieldIsValidString('category'),
      _fieldIsValidString('supplier'),
      _fieldIsValidNumber('purchase'),
      _fieldIsValidNumber('retailPrice'),
      _fieldIsValidNumber('wholesalePrice'),
      _fieldIsValidNumber('quantity'),
    ].where((element) => element == false);
    var createIfValid = ifDoElse(
        (f) => f.length > 0, (x) async => throw "Fix all issues", (x) async {
      product['retailPrice'] = int.parse(product['retailPrice'].toString());
      product['wholesalePrice'] =
          int.parse(product['wholesalePrice'].toString());
      product['quantity'] = int.parse(product['quantity'].toString());
      product['purchase'] = int.parse(product['purchase'].toString());
      product['stockable'] = true;
      product['purchasable'] = true;
      product['saleable'] = true;
      product['wholesaleQuantity'] = 1;
      product['images'] = [];
      var shop = await getActiveShop();
      return createProduct(product)(shop);
    });
    createIfValid(invalids).then((value) {
      product = {};
      navigateTo('/stock/products?reload=true');
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text(
                    "Error!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Text('$error'),
              ],
            ),
          ),
        ),
      );
    }).whenComplete(() {
      loading = false;
      notifyListeners();
    });
  }
}
