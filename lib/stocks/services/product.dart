import 'package:flutter/foundation.dart';
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

Future<dynamic> productCreateRemote({
  required Map product,
  required List<FileData?> fileData,
  required Map shop,
}) async {
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
    try {
      await saveLocalStock(shopToApp(shop), mergedProduct);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  });
}

Future<dynamic> productUpdateRemote({
  required Map product,
  required List<FileData?> fileData,
  required Map shop,
}) async {
  var urls = (await uploadFileToWeb3(fileData));
  product['images'] = urls.map((e) => e['link'] ?? '').toList();
  product['retailPrice'] = doubleOrZero(product['retailPrice']);
  product['barcode'] = product['barcode'] ?? '';
  // product['wholesalePrice'] = doubleOrZero(product['retailPrice']);
  product['stockable'] = product['stockable'] ?? true;
  product['quantity'] =
      product['stockable'] == true ? doubleOrZero(product['quantity']) : 0;
  product['purchase'] = doubleOrZero(product['purchase']);
  product['purchasable'] = true;
  product['saleable'] = true;
  product['wholesaleQuantity'] = 1;
  return productUpdateDetailsRestAPI(product: product, shop: shop)
      .then((value) async {
    product = {};
    var mergedProduct = {...product, ...value[0] ?? {}};
    try {
      await saveLocalStock(shopToApp(shop), mergedProduct);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  });
}
