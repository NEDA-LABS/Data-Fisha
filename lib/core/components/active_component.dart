import 'package:flutter/widgets.dart';

class ActiveComponent extends StatefulWidget {
  final Widget Function(
          BuildContext context, Map states, Function([Map value]) updateState)
      builder;
  final Map initialState;
  static const _map = {};

  const ActiveComponent(
      {Key key, this.initialState = _map, @required this.builder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ActiveComponent> {
  final Map states = {};

  _setState([value, skip = false]) {
    states.addAll(value is Map ? value : {});
    skip == false ? setState(() => states) : null;
  }

  @override
  void initState() {
    _setState(widget.initialState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, states, _setState);
}
