import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final Function validator;
  final TextInputType textInputType;
  final Key textFormFieldKey;

  const CustomTextField(
      {Key key,
      this.hintText,
      this.labelText,
      this.controller,
      this.validator,
      this.textInputType,
      this.textFormFieldKey})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.textFormFieldKey,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(15.0),
          borderSide: new BorderSide(),
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
      ),
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
