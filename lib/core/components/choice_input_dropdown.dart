import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/CancelProcessButtonsRow.dart';
import 'package:smartstock/core/components/DialogContentWrapper.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/full_screen_dialog.dart';
import 'package:smartstock/core/components/info_dialog.dart';
import 'package:smartstock/core/helpers/util.dart';
import 'package:crypto/crypto.dart';

class ChoiceInputDropdown extends StatefulWidget {
  final String comparisonKey;
  final Function(dynamic) onTitle;
  final Function(dynamic) onChoice;
  final dynamic choice;
  final bool multiple;
  final String label;
  final Widget Function()? onCreateBuilder;
  final Future Function(bool skipLocal) onLoadDataFuture;

  const ChoiceInputDropdown({
    super.key,
    required this.onTitle,
    required this.comparisonKey,
    required this.choice,
    required this.onChoice,
    required this.multiple,
    required this.label,
    required this.onLoadDataFuture,
    this.onCreateBuilder,
  });

  @override
  State<StatefulWidget> createState() => _ChoiceInputDropdown();
}

class _ChoiceInputDropdown extends State<ChoiceInputDropdown> {
  String _query = '';
  Timer? _debounce;
  final Map _selected = {};
  List _data = [];
  bool _loading = false;

  @override
  void initState() {
    _initialFetchData();
    super.initState();
  }

  _sha1e(dynamic data) {
    return '${sha1.convert(
      utf8.encode(
        jsonEncode(data is Map ? (data[widget.comparisonKey] ?? data) : data),
      ),
    )}';
  }

  _initialFetchData() {
    _updateState(() {
      _loading = true;
    });
    widget.onLoadDataFuture(false).then((value) async {
      _data = itOrEmptyArray(value);
      if (_data.isEmpty) {
        _data = itOrEmptyArray(await widget.onLoadDataFuture(true));
      }
      return _data;
    }).then((value) {
      itOrEmptyArray(widget.choice).forEach((element) {
        _selected[_sha1e(element)] = element;
      });
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      showTransactionCompleteDialog(context, error,canDismiss: true,title: 'Error');
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  _onRefresh() {
    _updateState(() {
      _loading = true;
    });
    widget.onLoadDataFuture(true).then((value) {
      _data = itOrEmptyArray(value);
    }).whenComplete(() {
      _updateState(() {
        _loading = false;
      });
    });
  }

  _updateState([VoidCallback? callback]) {
    if (mounted) {
      setState(callback ?? () {});
    }
  }

  _getItems(String q) => compute(_filterAndSort, {"items": _data, "q": q});

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
        var text = '${widget.onTitle(items[index]) ?? ''}';
        return widget.multiple
            ? CheckboxListTile(
                title: BodyLarge(text: firstLetterUpperCase(text)),
                value: _selected.keys.contains(_sha1e(items[index])),
                onChanged: (v) {
                  setState(() {
                    if (v == false) {
                      _selected.remove(_sha1e(items[index]));
                    } else {
                      _selected[_sha1e(items[index])] = items[index];
                    }
                  });
                },
              )
            : ListTile(
                title: BodyLarge(text: firstLetterUpperCase(text)),
                onTap: () {
                  widget.onChoice(items[index]);
                },
              );
      },
    );
  }

  _itemsList() {
    return Expanded(
      child: FutureBuilder<List>(
        builder: (context, snapshot) {
          return snapshot.hasData
              ? itOrEmptyArray(snapshot.data).isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BodyLarge(
                            text: _query.isNotEmpty
                                ? 'Sorry, filter "$_query" does not match any data.\n'
                                    'Please clear filter, refresh or create new data.'
                                : 'Sorry there is no data to show for selection.',
                          ),
                          const WhiteSpacer(height: 8),
                          InkWell(
                            hoverColor: Colors.transparent,
                            onTap: _onRefresh,
                            child: BodyLarge(
                              text: 'Refresh data',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                    )
                  : _listBuilder(snapshot.data)
              : Container();
        },
        initialData: _data,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // _getHeader(),
          _getSearchInput(),
          _loading
              ? const Expanded(
                  child: Center(child: CircularProgressIndicator()))
              : _itemsList(),
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

  _getBottomActions() {
    onClose() => Navigator.of(context).maybePop();
    return CancelProcessButtonsRow(
      cancelText: 'Cancel',
      proceedText: _selected.keys.isNotEmpty
          ? 'Proceed'
          : (widget.onCreateBuilder != null ? 'Create new' : null),
      onCancel: onClose,
      onProceed: _selected.keys.isNotEmpty
          ? () {
              // print(_selected.keys.toList());
              // print(_selected.values.toList());
              widget.onChoice(_selected.values.toList());
            }
          : _createNewHandler,
    );
  }

  _createNewHandler() {
    onClose() => Navigator.of(context).maybePop();
    if (widget.onCreateBuilder == null) {
      onClose();
    } else {
      onClose().whenComplete(() {
        var isSmallScreen = getIsSmallScreen(context);
        isSmallScreen
            ? showFullScreeDialog(context, (p0) {
                return Scaffold(
                  appBar: AppBar(
                    title: BodyLarge(
                        text: widget.label
                            .split(' ')
                            .map((e) => firstLetterUpperCase(e))
                            .join(' ')),
                    centerTitle: true,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: widget.onCreateBuilder!(),
                );
              })
            : showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child:
                        DialogContentWrapper(child: widget.onCreateBuilder!()),
                  );
                },
              );
      });
    }
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
