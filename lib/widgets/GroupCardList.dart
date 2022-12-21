import 'package:flutter/material.dart';

class GroupCardList extends StatefulWidget {
  String title;
  List<Widget> widgetList;
  GroupCardList({Key? key,required this.title,required this.widgetList}) : super(key: key);

  @override
  State<GroupCardList> createState() => _GroupCardListState();
}

class _GroupCardListState extends State<GroupCardList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: GestureDetector(
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          shadowColor: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: Text(widget.title,style: Theme.of(context).textTheme.caption,),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.widgetList,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
