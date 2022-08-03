import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget productCardItem({
  String productCategory,
  String productName,
  dynamic productPrice,
}) =>
    Card(
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
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            flex: 2,
          ),
          Spacer(flex: 1,),
          Expanded(
              child: Text(
            productPrice != null
                ? NumberFormat.currency(name: 'TZS ').format(productPrice)
                : "No Listed Price",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          )),
          // Spacer(
          //   flex: 1,
          // )
        ],
      ),
    );
