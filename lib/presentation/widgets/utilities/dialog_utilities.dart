import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
                  child: Text(AppLocalizations.of(context).translate('ok')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
  }

  static Widget showLoadingIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.all(5),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  static void showSnackBar(BuildContext context, String content) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(content),
      ));
    });
  }

  static PlatformAlertDialog createDeleteConfirmationDialog(
      BuildContext context) {
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context).translate('confirm')),
      content: Text(AppLocalizations.of(context)
          .translate('alert_dialog_delete_item_message')),
      actions: <Widget>[
        PlatformDialogAction(
            key: Key(Keys.DELETE_CONFIRMATION_DELETE_BUTTON),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)
                .translate('alert_dialog_delete_button'))),
        PlatformDialogAction(
          key: Key(Keys.DELETE_CONFIRMATION_CANCEL_BUTTON),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)
              .translate('alert_dialog_cancel_button')),
        ),
      ],
    );
  }

  static Widget createStackBehindDismiss(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      child: Icon(Icons.delete, color: Theme.of(context).errorColor),
    );
  }
}
