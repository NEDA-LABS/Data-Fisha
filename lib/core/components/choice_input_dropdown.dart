import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/button.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/services/util.dart';

class ChoiceInputDropdown extends StatefulWidget {
  final List items;
  final Function(dynamic) onTitle;
  final Function(dynamic) onText;
  final bool multiple;
  final String label;

  const ChoiceInputDropdown({
    Key? key,
    required this.items,
    required this.onTitle,
    required this.onText,
    required this.multiple,
    required this.label,
  }) : super(key: key);

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

  _getSearchInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextInput(
        onText: (d) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              _query = d;
            });
          });
        },
        placeholder: 'Filter...',
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
                title: Text(firstLetterUpperCase(
                    '${widget.onTitle(items[index]) ?? ''}')),
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
                title: BodyLarge(
                    text: firstLetterUpperCase(
                        '${widget.onTitle(items[index]) ?? ''}')),
                onTap: () {
                  widget.onText(widget.onTitle(items[index]));
                  Navigator.of(context).maybePop();
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _getHeader(),
          _getSearchInput(),
          _itemsList(),
          _getBottomActions()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _getHeader() {
    var text =
        widget.label.split(' ').map((e) => firstLetterUpperCase(e)).join(' ');
    onClose() => Navigator.of(context).maybePop();
    var icon = Icon(Icons.close, color: Theme.of(context).colorScheme.error);
    return Row(
      children: [
        Expanded(flex: 1, child: BodyLarge(text: text)),
        const WhiteSpacer(width: 16),
        IconButton(onPressed: onClose, icon: icon)
      ],
    );
  }

  _getBottomActions() {
    return Row(
      children: [
        FilledButton(onPressed: () {

        }, child: BodyLarge(text: "Create new",))
      ],
    );
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
