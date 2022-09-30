import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/util.dart';

class DashboardSummaryReportCard extends StatefulWidget {
  final String title;
  final future;
  final bool showRefresh;
  final String? link;

  const DashboardSummaryReportCard({
    required this.title,
    required this.future,
    this.link,
    this.showRefresh = true,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DashboardSummaryReportCard> {
  var updateState;

  @override
  void initState() {
    updateState =
        ifDoElse((x) => x is Map, (x) => setState(() {}), (x) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: _builder(widget.title, updateState), future: widget.future());
  }

  _loading() {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      child: const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _errorAndRetry(String err, state) => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(err),
            OutlinedButton(onPressed: () => state(), child: const Text('Retry'))
          ],
        ),
      );

  _dataAndRefresh(data, String title, updateState) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Text(
                NumberFormat().format(doubleOrZero('$data')),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            widget.showRefresh
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: OutlinedButton(
                        onPressed: () => updateState({}),
                        child: const Text('Refresh')),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  _showErrorOrContent(String title, updateState) => ifDoElse(
        (x) => x.hasError,
        (x) => _errorAndRetry('${x.error}', updateState),
        (x) => _dataAndRefresh(x.data, title, updateState),
      );

  Widget Function(BuildContext context, AsyncSnapshot snapshot) _builder(
    String title,
    updateState,
  ) {
    return (BuildContext context, AsyncSnapshot snapshot) {
      var builder = ifDoElse(
        (x) => snapshot.connectionState == ConnectionState.waiting,
        (x) => _loading(),
        _showErrorOrContent(title, updateState),
      );
      var line = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: horizontalLine(),
      );
      return Container(
        constraints: BoxConstraints(
            maxWidth: isSmallScreen(context)
                ? MediaQuery.of(context).size.width
                : 790/2,
            minHeight: 150),
        child: Card(
          child: Column(
            children: [
              SizedBox(
                height: 38,
                child: Center(
                    child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      color: Color(0xff525252)),
                )),
              ),
              line,
              builder(snapshot),
              line,
              SizedBox(
                height: 38,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: widget.link != null
                      ? TextButton(
                          onPressed: () {
                            navigateTo(widget.link ?? '/');
                          },
                          child: Text(
                            'Explore more',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Theme.of(context).primaryColorDark),
                          ),
                        )
                      : Container(),
                ),
              )
            ],
          ),
        ),
      );
    };
  }
}
