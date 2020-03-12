import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MultiSelectChip<T> extends StatefulWidget {
  final Iterable<T> userList;
  final Iterable<T> initialUserList;
  final Function(List<T>) onSelectionChanged;

  const MultiSelectChip(
      {Key key, this.userList, this.initialUserList, this.onSelectionChanged})
      : super(key: key);

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip> {
  List<T> _selectedItems = List();

  @override
  void initState() {
    if (widget.initialUserList != null) {
      _selectedItems = widget.initialUserList;
    } else {
      _selectedItems = widget.userList;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelectionChanged(_selectedItems);
    });
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.userList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          key: Key("receiver_${item.name}"),
          label: Text(item.name,
              overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
          selected: _selectedItems.contains(item),
          onSelected: (selected) {
            setState(() {
              _selectedItems.contains(item)
                  ? _selectedItems.remove(item)
                  : _selectedItems.add(item);
              widget.onSelectionChanged(_selectedItems);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("Select all"),
              onPressed: () {
                setState(() {
                  _selectedItems.addAll(widget.userList);
                  widget.onSelectionChanged(_selectedItems);
                });
              },
            ),
            FlatButton(
              child: Text("Select none"),
              onPressed: () {
                setState(() {
                  _selectedItems.clear();
                  widget.onSelectionChanged(_selectedItems);
                });
              },
            )
          ],
        ),
        Wrap(
          children: _buildChoiceList(),
        ),
      ],
    );
  }
}
