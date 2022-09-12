import 'package:flutter/material.dart';

void wholesaleBottomSheet({required BuildContext context, var stock}) {
  Scaffold.of(context).showBottomSheet((context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        height: 220,
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
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 19),
                                  ),
                                  Text(stock["wholesalePrice"].toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 25)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {})),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                        ),
                        onPressed: () {}),
                    const Flexible(
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), enabled: false),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.remove_circle,
                          color: Colors.green,
                        ),
                        onPressed: () {}),
                    OutlinedButton(
                      onPressed: () {},
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          height: 30,
                          width: 70,
                          child: const Center(
                            child: Text(
                              "ADD",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
      ));
}

// Widget productCardItem(
//     {String productCategory, String productName, String productPrice}) {
//   return Card(
//     color: Colors.white,
//     elevation: 4,
//     child: Column(
//       children: <Widget>[
//         Spacer(
//           flex: 1,
//         ),
//         Expanded(
//           child: Text(
//             productCategory != null ? productCategory : "No Listed Category",
//             style: TextStyle(color: Colors.grey),
//           ),
//         ),
//         Expanded(
//             child: Text(
//           productName != null ? productName : "No Listed Name",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         )),
//         Spacer(),
//         Expanded(
//             child: Text(
//           productPrice != null ? productPrice : "No Listed Price",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         )),
//         Spacer(
//           flex: 1,
//         )
//       ],
//     ),
//   );
// }
// // }
