import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;

  const CustomScaffold({Key key, this.appBarTitle, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMaterial(context)
          ? AppBar(
              title: Text(appBarTitle),
              elevation: 1,
            )
          : CupertinoNavigationBar(
              automaticallyImplyLeading: true,
              middle: Text(appBarTitle),
              leading: CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      body: body,
    );
  }
}
