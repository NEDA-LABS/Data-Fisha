import 'package:bfast/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/services/util.dart';

class ChooseShop extends StatelessWidget {
  const ChooseShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getState<ChooseShopState>().getShops();
    return consumerComponent<ChooseShopState>(builder: (context, state) {
      return ListView(
        // shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              "SELECT SHOP",
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                // color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: state?.shops.map((e) => _shop(e)).toList() ?? [],
          )
        ],
      );
    });
  }

  Widget _shop(var shop) {
    var imgSrc = _getUrl(shop);
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          ChooseShopState shopState = getState<ChooseShopState>();
          shopState.setCurrentShop(shop).catchError((e) {
            if (kDebugMode) {
              print(e);
            }
          });
        },
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Image.network(
                  imgSrc is String?imgSrc:'',
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.storefront,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 40,
                    );
                  },
                )),
            Container(
              width: 110,
              // decoration: const BoxDecoration(shape: BoxShape.circle),
              padding: const EdgeInsets.all(8),
              child: Text(
                shop['businessName'],
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  // color: Theme.of(context).primaryColor,
                  // fontSize: 14,
                  fontWeight: FontWeight.w500,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  _getUrl(shop) {
    var getEcommerce = propertyOr('ecommerce', (p0) => null);
    var getLogo = propertyOr('logo', (p0) => null);
    var execute = compose([getLogo, getEcommerce]);
    return execute(shop);
  }
}
