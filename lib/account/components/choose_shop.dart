import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/services/util.dart';

Widget get chooseShop {
  getState<ChooseShopState>().getShops();
  return consumerComponent<ChooseShopState>(
    builder: (context, state) => Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      color: Theme.of(context).primaryColorDark,
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  "Select shop.",
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              state!.shops.isNotEmpty
                  ? Wrap(
                      children: state.shops.map((e) => _shop(e)).toList(),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget _shop(var shop) {
  var imgSrc = _getUrl(shop);
  return Builder(builder: (context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(5),
          child: TextButton(
            onPressed: () {
              ChooseShopState shopState = getState<ChooseShopState>();
              shopState.setCurrentShop(shop).catchError((e) {
                if (kDebugMode) {
                  print(e);
                }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(
                //     content: Text('Fails to set a current shop'),
                //   ),
                // );
              });
            },
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: imgSrc is String
                  ? Image.network(imgSrc)
                  : Icon(
                      Icons.storefront,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
            ),
          ),
        ),
        Container(
          // width: 85,
          // decoration: const BoxDecoration(shape: BoxShape.circle),
          padding: const EdgeInsets.all(8),
          child: Text(
            shop['businessName'],
            softWrap: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  });
}

_getUrl(shop) {
  var getEcommerce = propertyOr('ecommerce', (p0) => null);
  var getLogo = propertyOr('logo', (p0) => null);
  var execute = compose([getLogo, getEcommerce]);
  return execute(shop);
}
