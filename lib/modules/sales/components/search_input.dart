import 'package:flutter/material.dart';
import 'package:smartstock_pos/modules/sales/states/sales.state.dart';
import 'package:smartstock_pos/util.dart';

PreferredSizeWidget searchInput() {
  SalesState state = getState<SalesState>();
  return PreferredSize(
    child: selectorComponent<SalesState, String>(
      selector: (_s) => _s.searchKeyword,
      builder: (context, value) => Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white70,
        ),
        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        width: MediaQuery.of(context).size.width * 0.9,
        alignment: Alignment.center,
        child: TextField(
          autofocus: false,
          maxLines: 1,
          // controller: state.searchInputController,
          minLines: 1,
          onChanged: (value) => state.filterProducts(value ?? ''),
          decoration: InputDecoration(
            hintText: "Enter a keyword...",
            border: InputBorder.none,
          ),
        ),
      ),
    ),
    preferredSize: Size.fromHeight(52),
  );
}
