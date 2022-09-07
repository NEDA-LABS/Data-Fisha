import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_product.dart';

class ProductCreateState extends ChangeNotifier {
  Map<String, dynamic> product = {};
  Map<String, dynamic> error = {};
  var loading = false;
  var isUpdate = false;

  setIsUpdate(bool a) {
    isUpdate = a;
  }

  clearFormState() {
    product = {};
  }

  updateFormState(Map<String, dynamic> data) {
    product.addAll(data);
  }

  refresh() => notifyListeners();

  _fieldIsValidString(field) {
    var valid = ifDoElse(
      (x) => product[x] is String && product[x].isNotEmpty,
      (x) => true,
      (x) {
        error[x] = 'Required';
        return false;
      },
    );
    return valid(field);
  }

  _fieldIsValidNumber(field) {
    var valid = ifDoElse(
      (x) =>
          int.tryParse('${product[x] ?? ''}'.isNotEmpty ? '${product[x]}' : '0')
              is int &&
          int.tryParse(
                  '${product[x] ?? ''}'.isNotEmpty ? '${product[x]}' : '0') >=
              0,
      (x) => true,
      (x) {
        error[x] = 'Required, and must be greater than zero';
        return false;
      },
    );
    return valid(field);
  }

  create(context) {
    error = {};
    loading = true;
    notifyListeners();
    var invalids = [
      isUpdate ? true : _fieldIsValidString('product'),
      _fieldIsValidString('category'),
      isUpdate ? true : _fieldIsValidString('supplier'),
      _fieldIsValidNumber('purchase'),
      _fieldIsValidNumber('retailPrice'),
      _fieldIsValidNumber('wholesalePrice'),
      isUpdate ? true : _fieldIsValidNumber('quantity'),
    ].where((element) => element == false);
    var createIfValid = ifDoElse(
        (f) => f.length > 0, (x) async => throw "Fix all issues", (x) async {
      product['retailPrice'] = int.parse(product['retailPrice'].toString());
      product['wholesalePrice'] =
          int.parse(product['wholesalePrice'].toString());
      if (!isUpdate) {
        product['quantity'] = int.parse(product['quantity'].toString());
      }
      product['purchase'] = int.parse(product['purchase'].toString());
      product['stockable'] = true;
      product['purchasable'] = true;
      product['saleable'] = true;
      if (!isUpdate) {
        product['wholesaleQuantity'] = 1;
      }
      if (!isUpdate) {
        product['images'] = [];
      }
      var shop = await getActiveShop();
      var createProduct = prepareCreateProduct(product);
      var updateProduct = prepareUpdateProductDetails({
        'barcode': product['barcode'],
        'category': product['category'],
        'purchase': product['purchase'],
        'retailPrice': product['retailPrice'],
        'wholesalePrice': product['wholesalePrice'],
        'id': product['id'],
      });
      if (isUpdate) {
        return updateProduct(shop);
      }
      return createProduct(shop);
    });
    createIfValid(invalids).then((value) {
      product = {};
      isUpdate = false;
      navigateTo('/stock/products');
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
              title: const Text("Error!",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              content: Text('$error')));
    }).whenComplete(() {
      loading = false;
      notifyListeners();
    });
  }
}
