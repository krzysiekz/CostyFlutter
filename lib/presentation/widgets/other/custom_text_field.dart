import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function validator;
  final TextInputType textInputType;
  final Key textFormFieldKey;
  final IconData iconData;

  const CustomTextField(
      {Key key,
      @required this.hintText,
      @required this.controller,
      this.validator,
      this.textInputType,
      this.textFormFieldKey,
      @required this.iconData})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      child: TextFormField(
        key: widget.textFormFieldKey,
        textCapitalization: TextCapitalization.sentences,
        keyboardType: widget.textInputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          prefixIcon: Icon(
            widget.iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          filled: true,
          fillColor: Color.fromRGBO(230, 230, 230, 1),
          isDense: true,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintText: widget.hintText,
        ),
        validator: widget.validator,
        controller: widget.controller,
      ),
    );
  }
}
