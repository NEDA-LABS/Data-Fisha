import 'package:flutter/material.dart';

Widget showProductLoading() => Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/data.png',
              height: 100,
              width: 100,
            ),
            CircularProgressIndicator(),
            Container(height: 20),
            Text(
              "Fetching products",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
