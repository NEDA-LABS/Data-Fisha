import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';
import 'package:smartstock/core/components/date_input.dart';

class ProductExpireInput extends StatefulWidget {
  final Function(dynamic value) onDate;
  final Function(bool value) onCanExpire;
  final bool trackExpire;
  final String date;
  final String error;

  const ProductExpireInput(
      {super.key,
      this.error = '',
      this.date = '',
      required this.onDate,
      required this.onCanExpire,
      required this.trackExpire});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductExpireInput> {
  bool _canExpire = false;

  @override
  void initState() {
    _canExpire = widget.trackExpire;
    super.initState();
  }

  _onCanExpire(value) {
    setState(() => _canExpire = (value ?? false));
    widget.onCanExpire(value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => _onCanExpire(!_canExpire),
          child: Row(
            children: [
              Checkbox(
                value: _canExpire,
                onChanged: _onCanExpire,
              ),
              const WhiteSpacer(width: 8),
              const BodyLarge(text: 'Track expire date?')
            ],
          ),
        ),
        _canExpire
            ? DateInput(
                onText: widget.onDate,
                placeholder: "YYYY-MM-DD",
                error: widget.error,
                initialText: widget.date,
                firstDate: DateTime.now(),
                initialDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 360 * 7)),
              )
            : Container()
      ],
    );
  }
}
