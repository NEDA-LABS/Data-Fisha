import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/account/states/shops.dart';
import 'package:smartstock/core/helpers/functional.dart';
import 'package:smartstock/smartstock.dart';
import 'package:smartstock/core/components/TitleMedium.dart';
import 'package:smartstock/core/helpers/util.dart';

class ChooseShop extends StatefulWidget {
  final OnGeAppMenu onGetModulesMenu;
  final OnGetInitialPage onGetInitialModule;

  const ChooseShop({
    super.key,
    required this.onGetModulesMenu,
    required this.onGetInitialModule,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChooseShop> {
  bool loading = false;
  List shops = [];

  @override
  void initState() {
    _fetchShops();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: const TitleMedium(text: "SELECT OFFICE"),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          children: shops.map((e) => _shop(e)).toList(),
        )
      ],
    );
  }

  _fetchShops() {
    setState(() {
      loading = true;
    });
    ChooseShopState().getShops().then((value) {
      shops = itOrEmptyArray(value);
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  Widget _shop(var shop) {
    var imgSrc = _getUrl(shop);
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          ChooseShopState shopState = ChooseShopState();
          shopState.setCurrentShop(shop).then((shop) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => SmartStock(
                  onGetModulesMenu: widget.onGetModulesMenu,
                  onGetInitialPage: widget.onGetInitialModule,
                ),
              ),
              (route) => false,
            );
          }).catchError((e) {
            if (kDebugMode) {
              print(e);
            }
          });
        },
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Image.network(
                  imgSrc is String ? imgSrc : '',
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
