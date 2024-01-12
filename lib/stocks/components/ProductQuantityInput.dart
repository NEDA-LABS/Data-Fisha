import 'package:flutter/material.dart';
import 'package:smartstock/core/components/BodyLarge.dart';
import 'package:smartstock/core/components/TextInput.dart';
import 'package:smartstock/core/components/WhiteSpacer.dart';

class ProductQuantityInput extends StatefulWidget {
  final Function(dynamic value) onQuantity;
  final Function(bool value) onCanTrack;
  final bool trackQuantity;
  final String text;
  final String error;

  const ProductQuantityInput(
      {super.key,
      this.error = '',
      this.text = '',
      required this.onQuantity,
      required this.onCanTrack,
      required this.trackQuantity});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProductQuantityInput> {
  bool _stockable = false;

  @override
  void initState() {
    _stockable = widget.trackQuantity;
    super.initState();
  }

  _onCanTrack(value) {
    setState(() => _stockable = (value ?? false));
    widget.onCanTrack(value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: ()=>_onCanTrack(!_stockable) ,
          child: Row(
            children: [
              Checkbox(
                value: _stockable,
                onChanged: _onCanTrack,
              ),
              const WhiteSpacer(width: 8),
              const BodyLarge(text: 'Track quantity?')
            ],
          ),
        ),
        _stockable
            ? TextInput(
                onText: widget.onQuantity,
                placeholder: "Quantity",
                error: widget.error,
                initialText: widget.text,
                type: TextInputType.number,
              )
            : Container()
      ],
    );
  }
}
