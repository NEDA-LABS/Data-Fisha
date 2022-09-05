import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_items.dart';
import 'package:smartstock/stocks/states/items_loading.dart';
import 'package:smartstock/stocks/states/product_create.dart';

class ItemCreateState extends ChangeNotifier {
  var item = {};
  var err = {};
  var createProgress = false;
  var requestError = '';

  updateState(Map<String, String> map) {
    item.addAll(map);
  }

  _validateName() {
    var isString = ifDoElse((x) => x, (x) => x, (x) {
      err['brand'] = 'Name required';
      return x;
    });
    return isString(item['brand'] is String && '${item['brand']}'.isNotEmpty);
  }

  _validItem() => and([_validateName]);

  create(context) async {
    err = {};
    requestError = '';
    createProgress = true;
    notifyListeners();
    var shop = await getActiveShop();
    var createIFValid = ifDoElse(
      (_) => _validItem(),
      createItem(item),
      (_) async => 'nope',
    );
    createIFValid(shop).then((r) {
      if (r == 'nope') return;
      var productFormState = getState<ProductCreateState>();
      productFormState.product['product'] =
          '${item['brand']} ${item['generic'] ?? ''} ${item['packaging'] ?? ''}';
      productFormState.refresh();
      navigator().maybePop();
      getState<ItemsLoadingState>().update(true);
    }).catchError((err) {
      requestError = '$err, Please try again';
    }).whenComplete(() {
      createProgress = false;
      notifyListeners();
      // getItemFromCacheOrRemote(skipLocal: true);
    });
  }
}
