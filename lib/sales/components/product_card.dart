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
          const Spacer(
            flex: 1,
          ),
          Expanded(
            child: Text(
              productCategory ?? "No Listed Category",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                productName ?? "No Listed Name",
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(flex: 1,),
          Expanded(
              child: Text(
            productPrice != null
                ? NumberFormat.currency(name: 'TZS ').format(productPrice)
                : "No Listed Price",
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          )),
          // Spacer(
          //   flex: 1,
          // )
        ],
      ),
    );
