import 'package:flutter/material.dart';

PreferredSizeWidget toolBarSearchInput(Function(String) onSearch, String placeholder) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(49),
    child: Container(
      // margin: const EdgeInsets.fromLTRB(0, 0, 0, 6),
      // height: 44,
      decoration: const BoxDecoration(
        // borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      // width: MediaQuery.of(context).size.width * 0.9,
      alignment: Alignment.centerLeft,
      // child:
      // Row(
      //   children: [
      //     Expanded(
            child: TextField(
              autofocus: false,
              maxLines: 1,
              minLines: 1,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: placeholder ?? "Search...",
                border: InputBorder.none,
              ),
            ),
          ),
          // const Icon(Icons.search, color: Colors.grey,)
        // ],
      // ),
    // ),
  );
}
