import 'package:bfast/bfast.dart';
import 'package:bfastui/adapters/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bfastui/bfastui.dart';
import 'package:smartstock/modules/sales/components/retail.component.dart';
import 'package:smartstock/modules/sales/states/sales.state.dart';

class RetailPage extends BFastUIPage {
  @override
  Widget build(var args) {
    return BFastUI.component().consumer<SalesState>((context, salesState) {
      // return FutureBuilder(
      //   future: salesState.getStockFromRemoteAndStoreInCache(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       print(snapshot.data[0]);
      //       return Scaffold(
      //         appBar: AppBar(
      //           title: Text("Retail"),
      //         ),
      //         floatingActionButton: FloatingActionButton(
      //             child: Icon(Icons.refresh),
      //             onPressed: () {
      //               salesState.getStockFromRemoteAndStoreInCache();
      //             }),
      //         body: GridView.builder(
      //             padding: EdgeInsets.all(10),
      //             itemCount: salesState.stocks.length,
      //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 2),
      //             itemBuilder: (context, index) {
      //               return RetailComponents().productCardItem(
      //                   productCategory: snapshot.data[index].productCategory,
      //                   productName: snapshot.data[index].productName,
      //                   productPrice:
      //                       snapshot.data[index].retailPrice.toString());
      //             }),
      //       );
      //     } else {
      //       return Container(
      //         color: Colors.white,
      //         child: Center(child: CircularProgressIndicator(),),
      //       );
            
      //     }
      //   },
      // );
      return Scaffold(
        appBar: AppBar(
          title: Text("Retail"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed:(){salesState.getStockFromRemoteAndStoreInCache();}
          ),
        body: GridView.builder(
            padding: EdgeInsets.all(10),
            itemCount: salesState.stocks.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return RetailComponents().productCardItem(
                  productCategory: salesState.stocks[index].productCategory,
                  productName: salesState.stocks[index].productName,
                  productPrice: salesState.stocks[index].retailPrice.toString());
            }),
      );
    });
  }
}
