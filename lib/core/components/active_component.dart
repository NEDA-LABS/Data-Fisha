import 'package:flutter/widgets.dart';

class ActiveComponent extends StatefulWidget {
  final Widget Function(
    Map states,
    Function([Map value]) updateState,
  ) builder;

  const ActiveComponent(this.builder, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ActiveComponent> {
  final Map states = {};

  _setState([value]) {
    states.addAll(value is Map ? value : {});
    setState(() => states);
  }

  @override
  Widget build(BuildContext context) => widget.builder(states, _setState);
}
