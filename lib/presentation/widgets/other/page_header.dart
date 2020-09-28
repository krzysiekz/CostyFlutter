import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../keys.dart';
import '../../../style_constants.dart';

class PageHeader extends StatelessWidget {
  final Widget _content;
  final void Function() _buttonOnPressed;
  final String _svgAsset;
  final String _title;
  final String _description;
  final String _buttonLabel;

  const PageHeader({
    Key key,
    @required Widget content,
    @required void Function() buttonOnPressed,
    @required String svgAsset,
    @required String title,
    @required String description,
    @required String buttonLabel,
  })  : _content = content,
        _buttonOnPressed = buttonOnPressed,
        _svgAsset = svgAsset,
        _title = title,
        _description = description,
        _buttonLabel = buttonLabel,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRect(child: buildHeader(context)),
        Expanded(child: _content),
      ],
    );
  }

  Stack buildHeader(BuildContext context) {
    return Stack(
      children: [
        buildHeaderBackground(),
        buildHeaderDescription(context),
      ],
    );
  }

  Transform buildHeaderBackground() {
    return Transform.translate(
      offset: const Offset(0, -80),
      child: Transform.scale(
        scale: 1.2,
        child: Stack(
          children: [
            buildBottomCard(),
            buildTopCard(),
          ],
        ),
      ),
    );
  }

  Transform buildTopCard() {
    return Transform.translate(
      offset: const Offset(30, 0),
      child: Transform.rotate(
        angle: -15 * pi / 180,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: StyleConstants.primaryGradient),
          ),
          Positioned(
            bottom: -5,
            child: SvgPicture.asset(_svgAsset, semanticsLabel: 'Header image'),
          )
        ]),
      ),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            gradient: StyleConstants.secondaryGradient),
      ),
    );
  }

  Padding buildHeaderDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 40),
      child: Wrap(
        direction: Axis.vertical,
        spacing: 15,
        children: [
          Text(_title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.primaryTextSize,
              )),
          Text(_description,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.secondaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
          FlatButton(
            key: const Key(Keys.projectlistAddProjectButtonKey),
            onPressed: _buttonOnPressed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
            color: Colors.white,
            child: Text(_buttonLabel,
                style: const TextStyle(
                  fontWeight: StyleConstants.buttonsTextFontWeight,
                  color: Colors.black,
                  fontSize: StyleConstants.buttonsTextSize,
                )),
          ),
        ],
      ),
    );
  }
}
