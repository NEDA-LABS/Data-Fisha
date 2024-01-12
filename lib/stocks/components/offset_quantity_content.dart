import 'package:flutter/material.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';
import 'package:smartstock/stocks/services/api_product.dart';

class OffsetQuantityContent extends StatefulWidget {
  final String? productId;
  final String? product;

  const OffsetQuantityContent(
      {required this.productId, required this.product, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OffsetQuantityContent> {
  dynamic quantity = 0;
  String qErr = '';
  String reqErr = '';
  bool progress = false;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(children: [
            TextInput(
                onText: (d) {
                  setState(() {
                    quantity = doubleOrZero(d);
                  });
                },
                initialText: '0',
                type: TextInputType.number,
                label: "Quantity",
                error: qErr),
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: progress ? null : _offsetQuantity,
                        child: Text(
                          progress ? "Waiting..." : "Offset quantity.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(reqErr)
          ]),
        ),
      );

  _offsetQuantity() {
    setState(() {
      qErr = '';
      reqErr = '';
      progress = true;
    });
    if (quantity == null) {
      setState(() {
        qErr = 'required';
        progress = false;
      });
      return;
    }
    _offset()
        .catchError((err) => setState(() {}))
        .then((value) => Navigator.of(context).maybePop())
        .whenComplete(() => setState(() {
              qErr = '';
              reqErr = '';
              progress = false;
            }));
  }

  Future _offset() async {
    var shop = await getActiveShop();
    var offsetQuantity = productOffsetQuantityRestAPI(body: {
      "quantity": quantity,
      "product": widget.product,
      "id": widget.productId,
    }, shop: shop);
    return offsetQuantity(shop);
  }
}
