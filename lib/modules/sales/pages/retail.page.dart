import 'package:bfastui/adapters/page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/sales/components/retail.component.dart';
import 'package:smartstock/modules/sales/states/sales.state.dart';

class RetailPage extends BFastUIPage {
  @override
  Widget build(var args) {
    return BFastUI.component().consumer<SalesState>((context, salesState) {
      return FutureBuilder(
        future: salesState.loading,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Retail"),
              ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    salesState.setLoadingFuture(
                        loading:
                            salesState.getStockFromRemoteAndStoreInCache());
                  }),
              body: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: salesState.stocks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return BFastUI.component()
                      .custom((context) => GestureDetector(
                            onTap: () {
                              RetailComponents().showBottomSheet(stock:salesState.stocks[index], context: context);
                            },
                            child: RetailComponents().productCardItem(
                                productCategory:
                                    salesState.stocks[index].productCategory,
                                productName:
                                    salesState.stocks[index].productName,
                                productPrice: salesState
                                    .stocks[index].retailPrice
                                    .toString()),
                          ));
                },
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    });
  }
}
