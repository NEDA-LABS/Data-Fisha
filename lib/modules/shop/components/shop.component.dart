import 'package:bfastui/bfastui.dart';
import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/shop/states/shops.state.dart';

class ShopComponents {
  Widget get chooseShop {
    BFastUI.getState<ChooseShopState>().getShops();
    return BFastUI.component().consumer<ChooseShopState>(
      (context, state) => Container(
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
                        fontSize: 38,
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
    return BFastUI.component().custom(
      (context) => Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: RaisedButton(
              onPressed: () {
                ChooseShopState shopState = BFastUI.getState<ChooseShopState>();
                shopState.setCurrentShop(shop).catchError((e) {
                  print(e);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fails to set a current shop'),
                    ),
                  );
                });
              },
              child: Container(
//              color: Colors.white,
                height: 150,
                width: 150,
                child: Icon(
                  Icons.store,
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
              ),
            ),
          ),
          Container(
            width: 145,
            child: Text(
              shop['businessName'],
              softWrap: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
