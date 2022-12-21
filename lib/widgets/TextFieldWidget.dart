import 'package:deta/assets/widgetThemes.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  bool readOnly;
  String labelTxt;
  String hintTxt;
  bool shouldHide;
  TextEditingController textController;
  Function(String)? onChange;
  TextFieldWidget(
      {Key? key,
      required this.readOnly,
      required this.labelTxt,
      required this.hintTxt,
      required this.shouldHide,
      required this.textController,
      required this.onChange})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    if (widget.shouldHide) {
      return TextFormField(
        readOnly: widget.readOnly,
        obscureText: !isVisible,
        controller: widget.textController,
        onChanged: widget.onChange,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: widget.labelTxt,
          labelStyle: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w500),
          hintText: widget.hintTxt,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: Icon(
                color: Theme.of(context).primaryColorDark,
                isVisible ? Icons.visibility : Icons.visibility_off),
          ),
        ),
      );
    }

    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.textController,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          labelText: widget.labelTxt,
          labelStyle: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.w500),
          hintText: widget.hintTxt),
      onChanged: widget.onChange,
    );
  }
}
