import 'package:flutter/material.dart';

import '../components/BodyMedium.dart';
import '../components/WhiteSpacer.dart';
import '../services/util.dart';
import '../models/HistogramData.dart';

class Histogram extends StatefulWidget {
  final List<HistogramData> data;
  final double height;

  const Histogram({Key? key, required this.data, this.height = 120})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Histogram> {
  double maxY = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    List<double> yOnly =
        widget.data.map((e) => double.tryParse(e.y) ?? 0).toList();
    yOnly.sort();
    setState(() {
      maxY = yOnly.last;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tertiaryColor = Theme.of(context).colorScheme.secondary;
    var primaryColor = Theme.of(context).colorScheme.tertiary;
    var selected = selectedIndex > widget.data.length - 1
        ? widget.data[0]
        : widget.data[selectedIndex];
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WhiteSpacer(height: 16),
            SizedBox(
              height: widget.height,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 30,
                        //0.173 * widget.height,
                        height: calculateHeight(widget.data[index]),
                        margin: const EdgeInsets.only(right: 5),
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                          color: selectedIndex == index
                              ? tertiaryColor
                              : primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const BodyMedium(text: 'Selected'),
            BodyMedium(text: 'x : ${selected.name} [ ${selected.x} ]'),
            BodyMedium(text: 'y: value [ ${formatNumber(selected.y)} ]'),
            const WhiteSpacer(height: 16),
          ],
        ),
      ),
    );
  }

  double calculateHeight(HistogramData data) {
    var y = double.tryParse(data.y) ?? 0;
    var rate = (y * widget.height) / (maxY);
    return rate == 0
        ? 1
        : rate.isNaN
            ? 1
            : rate;
  }
}
