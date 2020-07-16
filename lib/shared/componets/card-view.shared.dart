import 'package:flutter/material.dart';

class CardView extends StatelessWidget{
  final List<Widget> cardItems;

  CardView({this.cardItems});

  @override
  Widget build(BuildContext context) {
    double cardHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.height * 0.7);
    double cardWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width * 0.1);

    return Center(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 3,
                child: Container(
                  child: Center(
                    child: Column(
                      children: this.cardItems
                    ),
                  ),
                  height: cardHeight,
                  width: cardWidth,
                ),
              ),
              SizedBox(
                width: cardWidth,
                height: cardHeight/20,
              )
            ],
          ),
        );
  }

}