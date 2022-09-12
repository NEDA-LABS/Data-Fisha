import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/stocks/states/item_create.dart';

createItemContent() => Consumer<ItemCreateState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListBody(children: [
            TextInput(
                onText: (d) => state!.updateState({'brand': d}),
                label: "Brand name",
                error: state?.err['brand']??'',
                placeholder: 'E.g Smartstock'),
            TextInput(
                onText: (d) => state?.updateState({'generic': d}),
                label: "Generic name",
                placeholder: 'E.g Stock management system'),
            TextInput(
                onText: (d) => state?.updateState({'packaging': d}),
                label: "Packaging",
                placeholder: "E.g 10 Kg"),
            Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: state?.createProgress?? false
                            ? null
                            : () => state?.create(context),
                        child: Text(
                          state?.createProgress == true ? "Waiting..." : "Create item.",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(state?.requestError??'')
          ]),
        ),
      ),
    );
