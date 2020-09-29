import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../../app_localizations.dart';
import '../../../keys.dart';

class DialogUtilities {
  static void showAlertDialog(
      BuildContext context, String title, String content) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                  key: const Key(Keys.alertDialogOkButton),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context).translate('ok')),
                ),
              ],
            );
          });
    });
  }

  static Widget showLoadingIndicator(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Container(
              height: 20,
              width: 20,
              margin: const EdgeInsets.all(5),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  static void showSnackBar(BuildContext context, String content) {
    showToast(content);
  }

  static AlertDialog createDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('confirm')),
      content: Text(AppLocalizations.of(context)
          .translate('alert_dialog_delete_item_message')),
      actions: <Widget>[
        FlatButton(
            key: const Key(Keys.deleteConfirmationDeleteButton),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)
                .translate('alert_dialog_delete_button'))),
        FlatButton(
          key: const Key(Keys.deleteConfirmationCancelButton),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)
              .translate('alert_dialog_cancel_button')),
        ),
      ],
    );
  }
}
