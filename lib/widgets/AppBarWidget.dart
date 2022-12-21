import 'package:deta/screens/TabSettingsPage.dart';
import 'package:deta/screens/TabStatusPage.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColorDark,
    title: Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    ),
    actions: [
      PopupMenuButton(
          // add icon, by default "3 dot" icon
          // icon: Icon(Icons.book)
          itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 0,
            child: Text("Settings"),
          ),
          // const PopupMenuItem<int>(
          //   value: 1,
          //   child: Text("Status"),
          // ),
        ];
      }, onSelected: (value) {
        if (value == 0) {
          // print("Settings menu is selected.");
          GotoPage(context, const TabSettingsPage());

        } else if (value == 1) {
          GotoPage(context, const TabStatusPage());
        }
      }),
    ],
  );
}
