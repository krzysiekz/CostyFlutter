import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../../data/models/report_entry.dart';

class ReportEntryListItem extends StatefulWidget {
  final ReportEntry reportEntry;

  const ReportEntryListItem({Key key, this.reportEntry}) : super(key: key);

  @override
  _ReportEntryListItemState createState() => _ReportEntryListItemState();
}

class _ReportEntryListItemState extends State<ReportEntryListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                children: <Widget>[
                  Text(widget.reportEntry.amount.toStringAsFixed(2),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(widget.reportEntry.currency.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${AppLocalizations.of(context).translate('report_entry_item_from')} ${widget.reportEntry.sender.name}',
            ),
            const Divider(
              thickness: 0.4,
            ),
          ],
        ),
        subtitle: Text(
          '${AppLocalizations.of(context).translate('report_entry_item_to')} ${widget.reportEntry.receiver.name}',
        ),
      ),
    );
  }
}
