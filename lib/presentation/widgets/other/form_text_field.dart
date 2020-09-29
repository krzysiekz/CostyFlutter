import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../style_constants.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    Key key,
    @required TextEditingController controller,
    @required String hint,
    @required String textFieldKey,
    @required String Function(String) validator,
    TextInputType textInputType,
  })  : _controller = controller,
        _hint = hint,
        _textFieldKey = textFieldKey,
        _validator = validator,
        _textInputType = textInputType,
        super(key: key);

  final TextEditingController _controller;
  final String _hint;
  final String _textFieldKey;
  final String Function(String) _validator;
  final TextInputType _textInputType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_hint,
              style: const TextStyle(
                fontWeight: StyleConstants.buttonsTextFontWeight,
                color: StyleConstants.formLabelColor,
                fontSize: StyleConstants.buttonsTextSize,
              )),
          TextFormField(
            key: Key(_textFieldKey),
            controller: _controller,
            validator: _validator,
            keyboardType: _textInputType,
          ),
        ],
      ),
    );
  }
}
