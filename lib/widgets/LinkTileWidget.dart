import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/LinkText.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LinkTileWidget extends StatefulWidget {
  Widget leadingIcon;
  String text;
  String link;
  LinkTileWidget({Key? key,required this.leadingIcon,required this.text,required this.link}) : super(key: key);

  @override
  State<LinkTileWidget> createState() => _LinkTileWidgetState();

}

class _LinkTileWidgetState extends State<LinkTileWidget> {
  int tapCount = 0;

  @override
  Widget build(BuildContext context) {
    String txt =  widget.text.toString();
    String link = widget.link.toString();


    return InkWell(
      onTap: ()async{
        await openBrowser(link);
      },
      child: ListTile(
        leading: widget.leadingIcon,
        title: Text(txt,style: Theme.of(context).textTheme.headline1,),
      ),
    );
  }
}
