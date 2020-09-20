import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../app_localizations.dart';
import '../../../style_constants.dart';

class FormCancelButton extends StatelessWidget {
  const FormCancelButton({
    Key key,
    String buttonKey,
  })  : _buttonKey = buttonKey,
        super(key: key);

  final String _buttonKey;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      key: Key(_buttonKey),
      onPressed: () => Navigator.of(context).pop(),
      child: Text(AppLocalizations.of(context).translate('form_cancel_button'),
          style: const TextStyle(
            fontWeight: StyleConstants.buttonsTextFontWeight,
            color: Colors.red,
            fontSize: StyleConstants.buttonsTextSize,
          )),
    );
  }
}
