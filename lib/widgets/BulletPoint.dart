import 'package:flutter/material.dart';

class BulletPoint extends StatelessWidget {
  String text;
  BulletPoint({Key? key,required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        "\u2022",
        style: Theme.of(context).textTheme.caption,
      ), //bullet text
      const SizedBox(
        width: 10,
      ), //space between bullet and text
      Expanded(
        child: Text(
          text,
          style: Theme.of(context).textTheme.caption,
        ), //text
      )
    ]);
  }
}
