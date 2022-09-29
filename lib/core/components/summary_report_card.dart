import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/horizontal_line.dart';
import 'package:smartstock/core/services/util.dart';

class DashboardSummaryReportCard extends StatefulWidget {
  final String title;
  final Future Function() future;

  const DashboardSummaryReportCard({
    required this.title,
    required this.future,
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

  _loading() => const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      );

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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Text(
                NumberFormat().format(doubleOrZero('$data')),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: OutlinedButton(
                  onPressed: () => updateState(), child: const Text('Refresh')),
            )
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
  ){
    return (BuildContext context, AsyncSnapshot snapshot) {
      var builder = ifDoElse(
            (x) => snapshot.connectionState == ConnectionState.waiting,
            (x) => _loading(),
        _showErrorOrContent(title, updateState),
      );
      return Container(
        constraints: const BoxConstraints(maxWidth: 390, minHeight: 150),
        child: Column(
          children: [
            Card(child: builder(snapshot)),
            horizontalLine(),
            const SizedBox(
              height: 48,
              child: Text('Links'),
            )
          ],
        ),
      );
    };
  }
}
