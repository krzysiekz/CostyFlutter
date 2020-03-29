import 'package:costy/data/models/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../app_localizations.dart';

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
            labelText: widget.label,
            errorText: formState.hasError ? formState.errorText : null,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(),
            ),
          ),
          isEmpty: _selected == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Currency>(
              icon: Icon(
                Icons.arrow_downward,
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
                  child: Text(
                    currency.name,
                    key: Key('currency_${currency.name}'),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
      validator: (val) {
        return (val == null)
            ? AppLocalizations.of(context)
                .translate('form_currency_dropdown_error')
            : null;
      },
    );
  }
}
