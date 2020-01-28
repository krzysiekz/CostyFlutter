import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MultiSelectChip<T> extends StatefulWidget {
  final List<T> userList;
  final Function(List<T>) onSelectionChanged;

  MultiSelectChip(this.userList, {this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState<T> extends State<MultiSelectChip> {
  List<T> _selectedItems = List();

  @override
  void initState() {
    _selectedItems = widget.userList;
    super.initState();
  }

  _buildChoiceList() {
    List<Widget> choices = List();

    widget.userList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
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
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
