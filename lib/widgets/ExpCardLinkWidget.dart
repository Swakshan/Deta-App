import 'package:flutter/material.dart';

class ExpCardLinkWidget extends StatefulWidget {
  Widget title;
  Widget? subTitle;
  ButtonBar buttonBar;
  ExpCardLinkWidget({Key? key,required this.title,required this.subTitle, required this.buttonBar}) : super(key: key);

  @override
  State<ExpCardLinkWidget> createState() => _ExpCardLinkWidgetState();
}

class _ExpCardLinkWidgetState extends State<ExpCardLinkWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: GestureDetector(
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 10,
          shadowColor: Theme.of(context).primaryColor,
          child: ExpansionTile(
            title: widget.title,
            children: [
              widget.subTitle!,
              widget.buttonBar,
            ],
          ),
        ),
      ),
    );
  }
}
