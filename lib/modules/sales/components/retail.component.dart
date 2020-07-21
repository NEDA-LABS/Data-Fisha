import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Widget productCardItem(
      {String productCategory, String productName, String productPrice}) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Column(
        children: <Widget>[
          Spacer(
            flex: 1,
          ),
          Expanded(
            child: Text(
              productCategory != null ? productCategory : "No Listed Category",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(4),
              child: Text(
                productName != null ? productName : "No Listed Name",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Spacer(),
          Expanded(
              child: Text(
            productPrice != null
                ? NumberFormat.currency(name: 'TZS ')
                    .format(int.parse(productPrice))
                : "No Listed Price",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          )),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
