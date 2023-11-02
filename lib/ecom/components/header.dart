import 'package:flutter/material.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/ecom/components/brand.dart';

class EComHeader extends StatefulWidget {
  const EComHeader({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EComHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          const Expanded(flex: 1, child: EComBrand()),
          const WhiteSpacer(width: 8),
          Expanded(
            flex: 2,
            child: TextInput(
              onText: (p0) {},
              placeholder: 'Search...',
              icon: const Icon(Icons.search),
            ),
          ),
          const WhiteSpacer(width: 8),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.person_outline,
                        size: 38,
                      )),
                  const WhiteSpacer(width: 8),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 38,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
