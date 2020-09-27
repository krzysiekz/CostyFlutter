import 'package:flutter/widgets.dart';

import '../../../style_constants.dart';

class FormDecoration extends StatelessWidget {
  final String _title;
  final Widget _content;

  const FormDecoration({
    @required String title,
    @required Widget content,
  })  : _title = title,
        _content = content;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration:
                const BoxDecoration(gradient: StyleConstants.primaryGradient)),
        Positioned.fill(
          top: 36,
          child: Column(
            children: [
              Text(_title,
                  style: const TextStyle(
                    fontWeight: StyleConstants.formsTitleFontWeight,
                    color: StyleConstants.primaryTextColor,
                    fontSize: StyleConstants.formsTitleTextSize,
                  )),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: StyleConstants.backgroundColor),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: _content,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
