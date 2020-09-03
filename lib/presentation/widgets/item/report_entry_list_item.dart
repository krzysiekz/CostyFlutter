import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../../data/models/report_entry.dart';
import '../../../style_constants.dart';

class ReportEntryListItem extends StatefulWidget {
  final ReportEntry reportEntry;

  const ReportEntryListItem({Key key, this.reportEntry}) : super(key: key);

  @override
  _ReportEntryListItemState createState() => _ReportEntryListItemState();
}

class _ReportEntryListItemState extends State<ReportEntryListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: Stack(
        children: [
          buildBottomCard(),
          buildTopCard(),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(flex: 2, child: buildAmountSection()),
                Expanded(flex: 6, child: buildDescriptionSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Text(widget.reportEntry.sender.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(AppLocalizations.of(context).translate('report_entry_item_pays'),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.secondaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.descriptionTextSize,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(widget.reportEntry.receiver.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              )),
        ],
      ),
    );
  }

  Widget buildAmountSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(widget.reportEntry.amount.toStringAsFixed(2),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: StyleConstants.primaryFontWeight,
                  color: StyleConstants.primaryTextColor,
                  fontSize: StyleConstants.secondaryTextSize,
                )),
          ),
          Text(widget.reportEntry.currency.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: StyleConstants.primaryFontWeight,
                color: StyleConstants.primaryTextColor,
                fontSize: StyleConstants.secondaryTextSize,
              ))
        ],
      ),
    );
  }

  Container buildTopCard() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: StyleConstants.secondaryGradient),
    );
  }

  Transform buildBottomCard() {
    return Transform.rotate(
      angle: -5 * pi / 180,
      child: Container(
        height: 75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: StyleConstants.primaryGradient),
      ),
    );
  }
}
