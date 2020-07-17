import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetailComponents {
  Widget get company {
    return Center(
      child: InkWell(
        child: Text(
          "SmartStock @ 2020",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        onTap: () {},
      ),
    );
  }

  Widget productCardItem({String productCategory, String productName, String productPrice}) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Column(
        children: <Widget>[
          Spacer(flex: 1,),
          Expanded(child: Text(productCategory != null ? productCategory : "No Listed Category", style: TextStyle(color: Colors.grey),),),
          Expanded(child: Text(productName != null ? productName : "No Listed Name", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
          Spacer(),
          Expanded(child: Text(productPrice != null ? productPrice: "No Listed Price", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
          Spacer(flex: 1,)
        ],
      ),
    );
  }
}
