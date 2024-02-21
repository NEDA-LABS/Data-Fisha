import 'package:flutter/material.dart';
import 'package:smartstock/core/components/LabelLarge.dart';
import 'package:smartstock/core/components/input_box_decoration.dart';
import 'package:smartstock/core/components/input_error_message.dart';

dynamic sf(String s) {}

class MobileInput extends StatefulWidget {
  final String initialText;
  final Function(String) onText;
  final String error;

  const MobileInput({
    this.initialText = '',
    this.onText = sf,
    this.error = '',
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MobileInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 48,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _label('Mobile'),
            Container(
              decoration: getInputBoxDecoration(context, widget.error),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  prefixText: "+255",
                  // filled: true,
                  border: InputBorder.none,
                  // hintText: "Mobile",
                  counterText: '',
                ),
                onChanged: (s) => widget.onText(s),
                controller: controller,
                maxLength: 9,
                keyboardType: TextInputType.phone,
              ),
            ),
            InputErrorMessageOrEmpty(widget.error),
          ],
        ),
      ),
    );
  }

  _labelPadding() => const EdgeInsets.fromLTRB(0, 8, 0, 8);

  _label(label) => Padding(
      padding: _labelPadding(), child: LabelLarge(text: label ?? ''));
}
