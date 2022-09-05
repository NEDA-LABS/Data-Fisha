import 'package:flutter/material.dart';
import 'package:smartstock/core/components/button.dart';

productDetail(Map item) => Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(item['product'] ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            dense: true,
            onTap: () {},
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // outlineButton(onPressed: (){}, title: 'Edit'),
                // outlineButton(onPressed: (){}, title: 'Add quantity'),
                // outlineButton(onPressed: (){}, title: 'Reduce quantity'),
                // outlineButton(onPressed: (){}, title: 'Delete', textColor: Colors.red),
              ],
            ),
          ),
          ...item.keys.where((k) => k!='product').map((e) => listItem(e, item))
        ],
      ),
    );

listItem(e, item) => ListTile(
      title: Text('$e',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
      subtitle: Text(
        '${item[e]}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {},
      dense: true,
    );
