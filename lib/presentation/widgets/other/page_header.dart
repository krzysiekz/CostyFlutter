import 'dart:math';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../style_constants.dart';

class PageHeader extends StatelessWidget {
  final Widget _content;
  final void Function() _buttonOnPressed;
  final String _svgAsset;
  final String _title;
  final String _description;
  final String _buttonLabel;
  final bool _includeBackButton;
  final String _buttonKey;

  const PageHeader({
    Key key,
    @required Widget content,
    @required void Function() buttonOnPressed,
    @required String svgAsset,
    @required String title,
    @required String description,
    @required String buttonLabel,
    @required String buttonKey,
    bool includeBackButton = false,
  })  : _content = content,
        _buttonOnPressed = buttonOnPressed,
        _svgAsset = svgAsset,
        _title = title,
        _description = description,
        _buttonLabel = buttonLabel,
        _includeBackButton = includeBackButton,
        _buttonKey = buttonKey,
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
      offset: const Offset(0, -90),
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
            bottom: -20,
            left: 30,
            right: 0,
            child: Transform.scale(
                scale: 0.8,
                child: SvgPicture.asset(
                  _svgAsset,
                  semanticsLabel: 'Header image',
                )),
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
    final double leftPadding = _includeBackButton ? 0 : 30;
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_includeBackButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                FeatherIcons.chevronLeft,
                color: Colors.white,
              ),
            ),
          Wrap(
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
                key: Key(_buttonKey),
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
        ],
      ),
    );
  }
}
