import 'package:flutter/material.dart';

late ThemeData activeTheme;

final pinkTheme = ThemeData(
  primaryColor: Colors.pink[300],
  primaryColorDark: Colors.pink,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  )),
  fontFamily: 'Karla',
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    bodyText2:  TextStyle(color: Colors.black, fontSize: 28),
    caption:  TextStyle(color: Colors.black54, fontSize: 20),
    headline1:  TextStyle(color: Colors.blue, fontSize: 20,decoration: TextDecoration.underline),
  ),
);

final purpleTheme = ThemeData(
  primaryColor: Colors.deepPurpleAccent[300],
  primaryColorDark: Colors.deepPurpleAccent,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    backgroundColor: Colors.deepPurpleAccent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
  )),
  fontFamily: 'Karla',
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    bodyText2:  TextStyle(color: Colors.black, fontSize: 28),
    caption:  TextStyle(color: Colors.black54, fontSize: 20),
    headline1:  TextStyle(color: Colors.blue, fontSize: 20,decoration: TextDecoration.underline),
  ),
);

var THEME_ARR = [pinkTheme, purpleTheme];
