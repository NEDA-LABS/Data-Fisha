import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/text_input.dart';
import 'package:smartstock/core/services/util.dart';

class ChoiceInputDropdown extends StatefulWidget {
  final List items;
  final Function(dynamic) onTitle;
  final Function(String) onText;

  const ChoiceInputDropdown({
    Key? key,
    required this.items,
    required this.onTitle,
    required this.onText,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoiceInputDropdown();
}

class _ChoiceInputDropdown extends State<ChoiceInputDropdown> {
  String _query = '';
  Timer? _debounce;

  _getItems(String q) =>
      compute(_filterAndSort, {"items": widget.items, "q": q});

  _searchInput() => Padding(
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
          placeholder: 'Search...'));

  _listBuilder(items) => ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
          title: Text('${widget.onTitle(items[index])??''}'),
          onTap: () {
            widget.onText(widget.onTitle(items[index]));
            navigator().maybePop();
          }));

  Widget _itemsListBuilder(context, snapshot) =>
      snapshot.hasData ? _listBuilder(snapshot.data) : Container();

  _itemsList() => Expanded(
      child: FutureBuilder<List>(
          builder: _itemsListBuilder,
          initialData: widget.items,
          future: _getItems(_query)));

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
        //   child: Center(
        //     child: Container(
        //       height: 8,
        //       width: 80,
        //       decoration: BoxDecoration(
        //           color: Theme.of(context).primaryColorDark,
        //           borderRadius: const BorderRadius.all(Radius.circular(50))),
        //     ),
        //   ),
        // ),
        _searchInput(),
        _itemsList(),
      ]);

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
