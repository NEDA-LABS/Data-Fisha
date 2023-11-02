import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_stocks.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_product.dart';

Future deleteProduct(String? id) async {
  var shop = await getActiveShop();
  var delete = prepareDeleteProduct(id);
  return delete(shop).then((value) async {
    deleteLocalStock(shopToApp(shop), id).catchError((error) {});
  });
}

_fieldIsValidString(field, product, error) {
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

_fieldIsValidNumber(field, product, error) {
  var value = doubleOrZero(
      '${product[field] ?? ''}'.isNotEmpty ? '${product[field]}' : '-1');
  if (kDebugMode) {
    print(value);
  }
  if (value >= 0) {
    return true;
  } else {
    error[field] = 'Required, and must be greater than zero';
    return false;
  }
}

Future<dynamic> createOrUpdateProduct(
    context, error, loading, isUpdate, product, FileData? fileData) async {
  var invalids = [
    isUpdate ? true : _fieldIsValidString('product', product, error),
    _fieldIsValidString('category', product, error),
    // isUpdate ? true : _fieldIsValidString('supplier', product, error),
    _fieldIsValidNumber('purchase', product, error),
    _fieldIsValidNumber('retailPrice', product, error),
    _fieldIsValidNumber('wholesalePrice', product, error),
    isUpdate ? true : _fieldIsValidNumber('quantity', product, error),
  ].where((element) => element == false);
  var createIfValid = ifDoElse(
    (f) => f.length > 0,
    (x) async => throw "Please, enter all required fields",
    (x) async {
      if (fileData != null) {
        var url = (await uploadFileToWeb3(fileData))?['link'];
        product['images'] = url!=null?[url]:[];
      }
      product['retailPrice'] = doubleOrZero(product['retailPrice']);
      product['barcode'] = product['barcode'] ?? '';
      product['wholesalePrice'] = doubleOrZero(product['wholesalePrice']);
      if (!isUpdate) {
        product['quantity'] = doubleOrZero(product['quantity']);
      }
      product['purchase'] = doubleOrZero(product['purchase']);
      product['purchasable'] = true;
      if (!isUpdate) {
        product['wholesaleQuantity'] = 1;
      }
      // if (!isUpdate) {
      //   product['images'] = [];
      // }
      var shop = await getActiveShop();
      var createProduct = prepareCreateProduct(product);
      var updateProduct = prepareUpdateProductDetails({
        'barcode': product['barcode'] ?? '',
        'description': product['description'] ?? '',
        'name': product['product'],
        'expire': product['expire'],
        'category': product['category'],
        'purchase': product['purchase'],
        'retailPrice': product['retailPrice'],
        'wholesalePrice': product['wholesalePrice'],
        'images': product['images'],
        'id': product['id'],
      });
      if (isUpdate) {
        return updateProduct(shop);
      }
      return createProduct(shop);
    },
  );
  return createIfValid(invalids).then((value) async {
    product = {};
    var shop = await getActiveShop();
    saveLocalStock(shopToApp(shop), {...product, ...value[0] ?? {}})
        .catchError((err) {});
    isUpdate = false;
  });
}
