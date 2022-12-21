import 'package:deta/utils/Additonal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdvancedCardWidget extends StatefulWidget {
  int? version;
  String title;
  String? subTitle;
  CircleAvatar? circleAvatar;
  IconButton? iconButton;
  final VoidCallback? onTap;
  final VoidCallback? onHold;
  AdvancedCardWidget(
      {Key? key,
      this.version,
      required this.title,
      required this.subTitle,
      required this.circleAvatar,
      required this.iconButton,
      required this.onTap,
      required this.onHold})
      : super(key: key);

  @override
  State<AdvancedCardWidget> createState() => _AdvancedCardWidgetState();
}

class _AdvancedCardWidgetState extends State<AdvancedCardWidget> {
  @override
  Widget build(BuildContext context) {
    late InkWell titleTxt;
    late InkWell? subtitleTxt;

    titleTxt = InkWell(
      onTap: widget.onTap,
      child: Text(widget.title, style: Theme.of(context).textTheme.bodyText2),
      onLongPress: () {
        String txt = widget.title.toString();
        copy2Clipboard(context,txt);
      },
    );
    subtitleTxt = widget.subTitle != null
        ? InkWell(
            onTap: widget.onTap,
            child: Text(widget.subTitle!,
                style: Theme.of(context).textTheme.caption),
            onLongPress: () {
              String txt = widget.subTitle.toString();
              copy2Clipboard(context,txt);
            },
          )
        : null;

    if (widget.version != null) {
      if (widget.version == 2) {
        titleTxt = InkWell(
          onTap: widget.onTap,
          child: Text(widget.title, style: Theme.of(context).textTheme.caption),
          onLongPress: () {
            String txt = widget.title.toString();
            copy2Clipboard(context,txt);
          },
        );
        subtitleTxt = widget.subTitle != null
            ? InkWell(
                onTap: widget.onTap,
                child: Text(widget.subTitle!,
                    style: Theme.of(context).textTheme.bodyText2),
                onLongPress: () {
                  String txt = widget.subTitle.toString();
                  copy2Clipboard(context,txt);
                },
              )
            : null;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onHold,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 10,
          shadowColor: Theme.of(context).primaryColor,
          child: ListTile(
              leading: widget.circleAvatar,
              title: titleTxt,
              subtitle: subtitleTxt,
              trailing: widget.iconButton),
        ),
      ),
    );
  }
}
