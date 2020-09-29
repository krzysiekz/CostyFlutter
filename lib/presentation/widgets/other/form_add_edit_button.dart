import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../app_localizations.dart';
import '../../../style_constants.dart';

class FormAddEditButton extends StatelessWidget {
  final void Function() _onPressed;
  final bool _isEdit;

  const FormAddEditButton({
    Key key,
    @required void Function() onPressed,
    @required bool isEdit,
  })  : _onPressed = onPressed,
        _isEdit = isEdit,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: _onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0),
      ),
      color: StyleConstants.primaryColor,
      child: Text(
          _isEdit
              ? AppLocalizations.of(context).translate('edit')
              : AppLocalizations.of(context).translate('add'),
          style: const TextStyle(
            fontWeight: StyleConstants.buttonsTextFontWeight,
            color: Colors.white,
            fontSize: StyleConstants.buttonsTextSize,
          )),
    );
  }
}
