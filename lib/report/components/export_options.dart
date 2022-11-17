import 'package:flutter/material.dart';

dataExportOptions({onPdf,onCsv}){
  var subStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w200);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(
        title: Text('Export CSV'),
        subtitle: Text('comma separated', style: subStyle),
        leading: Icon(Icons.table_rows_outlined),
        onTap: onCsv,
      ),
      ListTile(
        title: Text('Export PDF'),
        subtitle: Text('with graphs and images', style: subStyle),
        leading: Icon(Icons.file_open),
        onTap: onPdf,
      )
    ],
  );
}