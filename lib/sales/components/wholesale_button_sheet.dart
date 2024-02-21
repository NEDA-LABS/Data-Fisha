import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/BodyMedium.dart';

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
                                  BodyMedium(text: stock["product"]),
                                  BodyLarge(
                                      text: stock["wholesalePrice"].toString()),
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
                          child: Center(
                            child: BodyLarge(
                                text: "ADD",
                                color: Theme.of(context).colorScheme.onPrimary),
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
