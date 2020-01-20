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
}
