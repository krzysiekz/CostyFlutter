import 'package:costy/data/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CurrencyDropdownField extends StatefulWidget {
  final List<Currency> currencies;
  final String label;
  final Function callback;
  final Currency initialValue;

  const CurrencyDropdownField(
      {Key key,
      @required this.currencies,
      @required this.label,
      @required this.callback,
      this.initialValue})
      : super(key: key);

  @override
  _CurrencyDropdownFieldState createState() => _CurrencyDropdownFieldState();
}

class _CurrencyDropdownFieldState extends State<CurrencyDropdownField> {
  var _selected;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Currency>(
      initialValue: widget.initialValue,
      builder: (FormFieldState<Currency> formState) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: Icon(
              Icons.monetization_on,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
            labelText: widget.label,
            errorText: formState.hasError ? formState.errorText : null,
          ),
          isEmpty: _selected == null,
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<Currency>(
              icon: Icon(
                Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              value: _selected,
              isDense: true,
              onChanged: (Currency newValue) {
                setState(() {
                  _selected = newValue;
                  formState.didChange(newValue);
                  widget.callback(newValue);
                });
              },
              items: widget.currencies
                  .map<DropdownMenuItem<Currency>>((Currency currency) {
                return DropdownMenuItem<Currency>(
                  value: currency,
                  child: Text(currency.name),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return (val == null) ? 'Please select a currency' : null;
      },
    );
  }
}
