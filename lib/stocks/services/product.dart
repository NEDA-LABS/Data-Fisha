import 'package:bfast/util.dart';
import 'package:smartstock/core/models/file_data.dart';
import 'package:smartstock/core/services/api_files.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/cache_stocks.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_product.dart';

Future deleteProduct(String? id) async {
  var shop = await getActiveShop();
  return productDeleteRestAPI(id: id, shop: shop).then((value) {
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
  if (value >= 0) {
    return true;
  } else {
    error[field] = 'Required, and must be greater than zero';
    return false;
  }
}

_costIsLowePriceValid(product, error) {
  var cost = doubleOrZero('${product?['purchase'] ?? ''}');
  var price = doubleOrZero('${product?['retailPrice'] ?? ''}');
  if (cost < price && '${product?['purchase'] ?? ''}'.isNotEmpty) {
    return true;
  } else {
    error['purchase'] = 'Required, and must be less than sell price';
    return false;
  }
}

Future<dynamic> createProductRemote({
  required Map product,
  required Map errors,
  required List<FileData?> fileData,
  required Map shop,
}) async {
  var invalids = [
    _fieldIsValidString('product', product, errors),
    _fieldIsValidString('category', product, errors),
    _costIsLowePriceValid(product, errors),
    _fieldIsValidNumber('retailPrice', product, errors),
    product['stockable'] != true
        ? true
        : _fieldIsValidNumber('quantity', product, errors),
  ].where((element) => element == false);
  if (invalids.isNotEmpty) {
    throw "Please, enter all required fields";
  }
  var urls = (await uploadFileToWeb3(fileData));
  product['images'] = urls.map((e) => e['link'] ?? '').toList();
  product['retailPrice'] = doubleOrZero(product['retailPrice']);
  product['barcode'] = product['barcode'] ?? '';
  product['wholesalePrice'] = doubleOrZero(product['retailPrice']);
  product['stockable'] = product['stockable'] ?? true;
  product['quantity'] =
      product['stockable'] == true ? doubleOrZero(product['quantity']) : 0;
  product['purchase'] = doubleOrZero(product['purchase']);
  product['purchasable'] = true;
  product['saleable'] = true;
  product['wholesaleQuantity'] = 1;
  return productCreateRestAPI(product: product, shop: shop).then((value) async {
    product = {};
    var mergedProduct = {...product, ...value[0] ?? {}};
    saveLocalStock(shopToApp(shop), mergedProduct).catchError((err) {});
  });
}

Future<dynamic> createOrUpdateProduct(context, error, loading, isUpdate,
    product, List<FileData?> fileData) async {
  // var invalids = [
  //   isUpdate ? true : _fieldIsValidString('product', product, error),
  //   _fieldIsValidString('category', product, error),
  //   // isUpdate ? true : _fieldIsValidString('supplier', product, error),
  //   _fieldIsValidNumber('purchase', product, error),
  //   _fieldIsValidNumber('retailPrice', product, error),
  //   // _fieldIsValidNumber('wholesalePrice', product, error),
  //   isUpdate ? true : _fieldIsValidNumber('quantity', product, error),
  // ].where((element) => element == false);
  // var createIfValid = ifDoElse(
  //   (f) => f.length > 0,
  //   (x) async => throw "Please, enter all required fields",
  //   (x) async {
  //     var urls = (await uploadFileToWeb3(fileData));
  //     product['images'] = urls.map((e) => e['link'] ?? '').toList();
  //
  //     product['retailPrice'] = doubleOrZero(product['retailPrice']);
  //     product['barcode'] = product['barcode'] ?? '';
  //     product['wholesalePrice'] = doubleOrZero(product['retailPrice']);
  //     if (!isUpdate) {
  //       product['quantity'] = doubleOrZero(product['quantity']);
  //     }
  //     product['purchase'] = doubleOrZero(product['purchase']);
  //     product['purchasable'] = true;
  //     if (!isUpdate) {
  //       product['wholesaleQuantity'] = 1;
  //     }
  //     // if (!isUpdate) {
  //     //   product['images'] = [];
  //     // }
  //     var shop = await getActiveShop();
  //     var createProduct = prepareCreateProduct(product);
  //     var updateProduct = prepareUpdateProductDetails({
  //       'barcode': product['barcode'] ?? '',
  //       'description': product['description'] ?? '',
  //       'name': product['product'],
  //       'expire': product['expire'],
  //       'category': product['category'],
  //       'purchase': product['purchase'],
  //       'retailPrice': product['retailPrice'],
  //       'wholesalePrice': product['retailPrice'],
  //       'images': product['images'],
  //       'id': product['id'],
  //     });
  //     if (isUpdate) {
  //       return updateProduct(shop);
  //     }
  //     return createProduct(shop);
  //   },
  // );
  // return createIfValid(invalids).then((value) async {
  //   product = {};
  //   saveLocalStock(shopToApp(shop), {...product, ...value[0] ?? {}})
  //       .catchError((err) {});
  //   isUpdate = false;
  // });
}
