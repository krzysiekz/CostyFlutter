import 'package:costy/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../app_localizations.dart';

class MultiSelectChip<T> extends StatelessWidget {
  final Iterable<T> userList;
  final Iterable<T> selectedUserList;
  final Function(List<T>) onSelectionChanged;
  final Function(T item) extractLabelFunction;

  const MultiSelectChip({
    Key key,
    this.userList,
    this.selectedUserList,
    this.onSelectionChanged,
    this.extractLabelFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              key: Key(Keys.MULTI_SELECT_CHIP_SELECT_ALL),
              child: Text(AppLocalizations.of(context).translate(
                  'expense_form_multi_select_chip_select_all_button')),
              onPressed: () => onSelectionChanged(userList),
            ),
            FlatButton(
              key: Key(Keys.MULTI_SELECT_CHIP_SELECT_NONE),
              child: Text(AppLocalizations.of(context).translate(
                  'expense_form_multi_select_chip_select_none_button')),
              onPressed: () => onSelectionChanged([]),
            )
          ],
        ),
        Wrap(
          children: _buildChoiceList(context),
        ),
      ],
    );
  }

  _buildChoiceList(BuildContext ctx) {
    List<Widget> choices = List();

    userList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Colors.blue.withOpacity(0.8),
          key: Key("receiver_${extractLabelFunction(item)}"),
          label: Text(
            extractLabelFunction(item),
            overflow: TextOverflow.fade,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
                color: Theme.of(ctx).textTheme.title.color),
          ),
          selected: selectedUserList.contains(item),
          onSelected: (selected) {
            List.from(selectedUserList)..add(item);
            selectedUserList.contains(item)
                ? onSelectionChanged(List.from(selectedUserList)..remove(item))
                : onSelectionChanged(List.from(selectedUserList)..add(item));
          },
        ),
      ));
    });
    return choices;
  }
}
