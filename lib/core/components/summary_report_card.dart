import 'package:bfast/util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartstock/core/components/active_component.dart';

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

_dataAndRefresh(data, String title, updateState) => Padding(
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
                NumberFormat().format(data),
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

_showErrorOrContent(String title, updateState) => ifDoElse(
      (x) => x.hasError,
      (x) => _errorAndRetry('${x.error}', updateState),
      (x) => _dataAndRefresh(x.data, title, updateState),
    );

Widget Function(BuildContext context, AsyncSnapshot snapshot) _builder(
  String title,
  updateState,
) =>
    (BuildContext context, AsyncSnapshot snapshot) {
      var builder = ifDoElse(
        (x) => snapshot.connectionState == ConnectionState.waiting,
        (x) => _loading(),
        _showErrorOrContent(title, updateState),
      );
      return Container(
        constraints: const BoxConstraints(maxWidth: 390, minHeight: 150),
        child: Card(child: builder(snapshot)),
      );
    };

Widget numberSummaryReportCard({
  @required String title,
  @required Future Function() future,
}) =>
    ActiveComponent(builder: (context,states, updateState) =>
        FutureBuilder(builder: _builder(title, updateState), future: future()));
