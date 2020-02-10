import 'package:flutter/material.dart';

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
                  child: const Text('Ok'),
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

  static AlertDialog createDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm"),
      content: const Text("Are you sure you wish to delete this item?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("DELETE")),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("CANCEL"),
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
