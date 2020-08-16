import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../app_localizations.dart';
import '../../../data/models/currency.dart';

class CurrencyDropdownField extends StatefulWidget {
  final List<Currency> currencies;
  final Function callback;
  final Currency initialValue;

  const CurrencyDropdownField(
      {Key key,
      @required this.currencies,
      @required this.callback,
      this.initialValue})
      : super(key: key);

  @override
  _CurrencyDropdownFieldState createState() => _CurrencyDropdownFieldState();
}

class _CurrencyDropdownFieldState extends State<CurrencyDropdownField> {
  Currency _selected;

  @override
  void initState() {
    _selected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      child: FormField<Currency>(
        initialValue: widget.initialValue,
        builder: (FormFieldState<Currency> formState) {
          return InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
              prefixIcon: Icon(
                context.platformIcons.settings,
                color: Colors.blue,
              ),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              isDense: true,
              hintText: AppLocalizations.of(context)
                  .translate('form_currency_dropdown_hint'),
              errorText: formState.hasError ? formState.errorText : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
            ),
            isEmpty: _selected == null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Currency>(
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Colors.blue,
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
      ),
    );
  }
}
