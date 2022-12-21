import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UpdateModel.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/widgets/BulletPoint.dart';
import 'package:deta/widgets/LinkText.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, no }

class UpdDialog {
  static Future<DialogAction> AlertBox(
    BuildContext context,
    String title,
    UpdateModel updateModel,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        late List<Widget> changelogs= [];
        List.generate(updateModel.changelogs!.length, (index){
          String cl= updateModel.changelogs![index].toString();
          changelogs.add(BulletPoint(text: cl.toString(),));
        });


        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$VERSION: ${updateModel.version.toString()}",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
                child: Text(
                  formatDate(updateModel!.date.toString(),dateformat: "yMMMMd"),
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              const Divider(
                height: 10,
                thickness: 3,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: changelogs,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () => Navigator.of(context).pop(DialogAction.no),
              child: const Text(BTN_CANCEL),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () async{
                String domainName = updateModel.link.toString();
                await openBrowser(domainName);
              },
              child: const Text(
                BTN_DOWNLOAD,
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
