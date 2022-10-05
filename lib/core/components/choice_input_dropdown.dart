import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';

class ChoiceInputDropdown extends StatefulWidget {
  final List items;
  final Function(dynamic) onTitle;
  final Function(dynamic) onText;
  final bool multiple;

  const ChoiceInputDropdown(
      {Key? key,
      required this.items,
      required this.onTitle,
      required this.onText,
      required this.multiple})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoiceInputDropdown();
}

class _ChoiceInputDropdown extends State<ChoiceInputDropdown> {
  String _query = '';
  Timer? _debounce;
  Map checked = {};
  Set selected = {};

  _getItems(String q) =>
      compute(_filterAndSort, {"items": widget.items, "q": q});

  _searchInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: TextInput(
        onText: (d) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _query = d;
            });
          });
        },
        placeholder: 'Search...',
      ),
    );
  }

  _listBuilder(items) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return widget.multiple
            ? CheckboxListTile(
                title: Text('${widget.onTitle(items[index]) ?? ''}'),
                value: checked[index] ?? false,
                onChanged: (v) {
                  setState(() {
                    checked[index] = v;
                    if (v == false) {
                      selected.remove(items[index]);
                    } else {
                      selected.add(items[index]);
                    }
                    widget.onText(selected.toList());
                  });
                },
              )
            : ListTile(
                title: Text('${widget.onTitle(items[index]) ?? ''}'),
                onTap: () {
                  widget.onText(widget.onTitle(items[index]));
                  navigator().maybePop();
                },
              );
      },
    );
  }

  Widget _itemsListBuilder(context, snapshot) =>
      snapshot.hasData ? _listBuilder(snapshot.data) : Container();

  _itemsList() {
    return Expanded(
      child: FutureBuilder<List>(
        builder: _itemsListBuilder,
        initialData: widget.items,
        future: _getItems(_query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _searchInput(),
        _itemsList(),
        outlineActionButton(
            title: 'Close',
            onPressed: () {
              navigator().maybePop();
            })
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

Future<List> _filterAndSort(Map data) async {
  var items = data['items'];
  String? stringLike = data['q'];
  _where(x) =>
      x != null && '$x'.toLowerCase().contains(stringLike!.toLowerCase());
  items = items.where(_where).toList();
  items.sort((a, b) => '$a'.toLowerCase().compareTo('$b'.toLowerCase()));
  return items;
}
