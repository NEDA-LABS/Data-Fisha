import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/util.dart';
import 'text_input.dart';

class ChoiceInputContent extends StatefulWidget {
  final List items;
  final Function(dynamic) onTitle;
  final Function(String) onText;

  const ChoiceInputContent({
    Key key,
    @required this.items,
    @required this.onTitle,
    @required this.onText,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChoiceInputContent();
}

class _ChoiceInputContent extends State<ChoiceInputContent> {
  String _query = '';
  Timer _debounce;

  _items(String q) => compute(_filterAndSort, {"items": widget.items, "q": q});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            textInput(
                onText: (d) {
                  if (_debounce?.isActive ?? false) _debounce.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () {
                    setState(() {
                      _query = d;
                    });
                  });
                },
                placeholder: 'Search...'),
            Expanded(
              child: FutureBuilder(
                builder: (c, snapshot) => snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                              '${widget.onTitle(snapshot.data[index])}' ?? ''),
                          onTap: () {
                            widget.onText(widget.onTitle(snapshot.data[index]));
                            navigator().maybePop();
                          },
                        ),
                      )
                    : Container(),
                initialData: widget.items,
                future: _items(_query),
              ),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

Future<List> _filterAndSort(Map data) async {
  var items = data['items'];
  String stringLike = data['q'];
  _where(x) =>
      x != null && '$x'.toLowerCase().contains(stringLike.toLowerCase());

  items = items.where(_where).toList();
  items.sort((a, b) => '$a'.toLowerCase().compareTo('$b'.toLowerCase()));
  return items;
}
