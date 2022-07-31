import 'package:flutter/material.dart';

class WholesaleComponents {
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

  void showBottomSheet({ BuildContext context, var stock}) {
    Scaffold.of(context).showBottomSheet((context) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Card(
            elevation: 30,
            child: Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(

                              flex: 1,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      stock["product"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 19),
                                    ),
                                    Text(stock["wholesalePrice"].toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 25)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                child: IconButton(
                                    icon: Icon(Icons.close), onPressed: () {})),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {}),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), enabled: false),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.green,
                          ),
                          onPressed: () {}),
                      FlatButton(
                        onPressed: () {},
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            height: 30,
                            width: 70,
                            child: Center(
                              child: Text(
                                "ADD",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
               
                ],
              ),

            ),
          ),
          height: 220,
        ));
  }


  Widget productCardItem({ String productCategory,  String productName,  String productPrice}) {
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
