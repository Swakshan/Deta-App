import 'package:deta/assets/Constants.dart';
import 'package:flutter/material.dart';

class ExpCardListWidget extends StatefulWidget {
  String title;
  List<dynamic>? txtList;
  final VoidCallback? onTap;
  ExpCardListWidget(
      {Key? key,
      required this.title,
      required this.txtList,
      required this.onTap})
      : super(key: key);

  @override
  State<ExpCardListWidget> createState() => _ExpCardListWidgetState();
}

class _ExpCardListWidgetState extends State<ExpCardListWidget> {


  @override
  Widget build(BuildContext context) {
    List<Widget> textList=[];
    if(widget.txtList!=null){
      for(int i=1;i<widget.txtList!.length;i++){
        var txt = widget.txtList![i];
          textList.add(
              Text(
               "${i}. $txt",
                style: Theme.of(context).textTheme.caption,
              )
          );
      }
    }
    else{
      textList.add(
          Text(
            INFO_NULL,
            style: Theme.of(context).textTheme.caption,
          )
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 10,
          shadowColor: Theme.of(context).primaryColor,
          child: ExpansionTile(
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: textList,
                ),
              ),],
          ),
        ),
      ),
    );
  }
}
