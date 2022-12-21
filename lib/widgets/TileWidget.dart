import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TileWidget extends StatefulWidget {
  IconData leadingIcon;
  String text;
  TileWidget({Key? key,required this.leadingIcon,required this.text}) : super(key: key);

  @override
  State<TileWidget> createState() => _TileWidgetState();

}

class _TileWidgetState extends State<TileWidget> {
  int tapCount = 0;
  VoidCallback? onTap = null;

  @override
  Widget build(BuildContext context) {
    String txt =  widget.text.toString();

    if(txt.contains(VERSION)){
      onTap = ()async{
        setState(() {
          tapCount+=1;
          String msg = "Deta ${tapCount.toString()}";
          toaster(context, msg);
        });
      };
    }
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(widget.leadingIcon,
          color: Theme.of(context).primaryColorDark,),
        title: Text(txt,style: Theme.of(context).textTheme.caption,),
      ),
    );
  }
}
