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

  Widget productCardItem(
      {String productCategory, String productName, int productPrice}) {
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
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            flex: 2,
          ),
          Spacer(),
          Expanded(
              child: Text(
            // productPrice != null
                // ? NumberFormat.currency(name: 'TZS ')
                //     .format(productPrice)
                // :
                "No Listed Price",
                softWrap: true,
                overflow: TextOverflow.ellipsis,
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
