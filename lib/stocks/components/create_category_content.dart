import 'package:builders/builders.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/stocks/states/category_create.dart';

createCategoryContent() => Consumer<CategoryCreateState>(
    builder: (context, state) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: ListBody(children: [
          TextInput(
              onText: (d) => state!.updateState({'name': d}),
              label: "Name",
              error: state!.err['name']??''),
          TextInput(
              onText: (d) => state.updateState({'description': d}),
              label: "Description",
              lines: 3,
              placeholder: 'Optional'),
          Container(
              height: 64,
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(children: [
                Expanded(
                    child: SizedBox(
                        height: 40,
                        child: OutlinedButton(
                            onPressed: state.createProgress
                                ? null
                                : () => state.create(context),
                            child: Text(
                                state.createProgress
                                    ? "Waiting..."
                                    : "Create category.",
                                style: const TextStyle(fontSize: 16)))))
              ])),
          Text(state.requestError)
        ]))));
