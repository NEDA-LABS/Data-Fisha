import 'package:bfast/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/services/cache_shop.dart';
import 'package:smartstock/core/services/util.dart';

class EComHeaderImage extends StatelessWidget {
  const EComHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: getActiveShop(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var getCover =
                compose([propertyOrNull('cover'), propertyOrNull('ecommerce')]);
            return Image.network(
              getCover(snapshot.data),
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    color: Theme.of(context).colorScheme.background);
              },
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress?.expectedTotalBytes == null
                    ? child
                    : Container(
                        color: Theme.of(context).colorScheme.background);
              },
            );
          }
          return Container(color: Theme.of(context).colorScheme.background);
        },
      ),
    );
  }
}
