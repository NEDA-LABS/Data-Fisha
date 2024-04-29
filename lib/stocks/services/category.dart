import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:smartstock/stocks/services/api_categories.dart';
import 'package:smartstock/stocks/services/category_cache.dart';

Future<List<dynamic>> getCategoryFromCacheOrRemote(
    [skipLocal = false, stringLike = '']) async {
  var shop = await getActiveShop();
  var categories = skipLocal ? [] : await getLocalCategories(shopToApp(shop));
  var getItOrRemoteAndSave = ifDoElse(
    (x) => x == null || (x is List && x.isEmpty),
    (_) async {
      List rCategories = await getAllCategoriesAPI(shop);
      rCategories = await compute(
          _filterAndSort, {"categories": rCategories, "query": stringLike});
      await saveLocalCategories(shopToApp(shop), rCategories);
      return rCategories;
    },
    (x) => compute(_filterAndSort, {"categories": x, "query": stringLike}),
  );
  var c = await getItOrRemoteAndSave(categories);
  if(c is List && c.isEmpty){
    return [
      {
        "id": 1436,
        "name": "plastic -pp",
        "image": "",
        "description": "null",
        "createdat": "2024-03-03T10:47:45.833Z",
        "updatedat": "2024-03-03T10:47:45.833Z"
      },
      {
        "id": 1439,
        "name": "plastic - pvc",
        "image": "",
        "description": "null",
        "createdat": "2024-03-03T10:48:24.025Z",
        "updatedat": "2024-03-03T10:48:24.025Z"
      },
      {
        "id": 1438,
        "name": "Plastic - HDPE",
        "image": "",
        "description": "",
        "createdat": "2024-03-03T10:48:11.523Z",
        "updatedat": "2024-03-03T10:48:11.523Z"
      },
      {
        "id": 1441,
        "name": "Organic",
        "image": "","description": "Organic waste description",
        "createdat": "2024-03-03T13:44:04.699Z",
        "updatedat": "2024-03-03T13:44:04.699Z"
      },
      {
        "id": 1437,
        "name": "Plastic - LDPE",
        "image": "","description": "Maelezo",
        "createdat": "2024-03-03T10:47:57.277Z",
        "updatedat": "2024-03-03T10:47:57.277Z"
      },
      {
        "id": 1435,
        "name": "Plastic - PET",
        "image": "","description": "Platic aina ya PET",
        "createdat": "2024-03-03T10:47:27.087Z",
        "updatedat": "2024-03-03T10:47:27.087Z"
      },
      {
        "id": 1491,
        "name": "Bio waste",
        "image": "","description": "bio degrable waste from Mikocheni ",
        "createdat": "2024-03-19T08:12:41.262Z",
        "updatedat": "2024-03-19T08:12:41.262Z"
      },
      {
        "id": 1492,
        "name": "Test",
        "image": "","description": "Test description",
        "createdat": "2024-03-20T06:28:11.172Z",
        "updatedat": "2024-03-20T06:28:11.172Z"
      },
      {
        "id": 1496,
        "name": "community Reforstration ",
        "image": "","description": "",
        "createdat": "2024-04-05T20:59:08.278Z",
        "updatedat": "2024-04-05T20:59:08.278Z"
      },
      {
        "id": 1498,
        "name": "BLACK LABEL ",
        "image": "","description": "money ",
        "createdat": "2024-04-06T12:09:44.895Z",
        "updatedat": "2024-04-06T12:09:44.895Z"
      }
    ];
  }
  return c;
}

Future<List> _filterAndSort(Map data) async {
  var categories = data['categories'];
  String stringLike = data['query'] ?? '';
  _where(x) =>
      x['name'] != null &&
      '${x['name']}'.toLowerCase().contains(stringLike.toLowerCase());

  categories = categories.where(_where).toList();
  categories.sort((a, b) =>
      '${a['name']}'.toLowerCase().compareTo('${b['name']}'.toLowerCase()));
  return categories;
}
