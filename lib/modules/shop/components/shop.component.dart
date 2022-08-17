import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';
import 'package:smartstock_pos/util.dart';

class ShopComponents {
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
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Choose Shop",
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                state.shops.length > 0
                    ? Wrap(
                        children:
                            state.shops.map((e) => this._shop(e)).toList(),
                      )
                    : Container(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                        alignment: Alignment.center,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _shop(var shop) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: TextButton(
              onPressed: () {
                ChooseShopState shopState = getState<ChooseShopState>();
                shopState.setCurrentShop(shop).catchError((e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fails to set a current shop'),
                    ),
                  );
                });
              },
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Icon(
                  Icons.store,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
          Container(
            width: 85,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Text(
              shop['businessName'],
              softWrap: true,
              style: TextStyle(
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
}
