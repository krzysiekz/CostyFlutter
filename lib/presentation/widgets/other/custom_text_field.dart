import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final Function validator;
  final TextInputType textInputType;

  const CustomTextField(
      {Key key,
      this.icon,
      this.hintText,
      this.labelText,
      this.controller,
      this.validator,
      this.textInputType})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        icon: Icon(
          widget.icon,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
      ),
      validator: widget.validator,
      controller: widget.controller,
    );
  }
}
