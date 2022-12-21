import 'package:deta/assets/Constants.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, no }

class Dialogs {
  static Future<DialogAction> AlertBox(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(DialogAction.no),
              child: const Text(BTN_NO),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              child: const Text(
                BTN_YES,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.no;
  }
}
