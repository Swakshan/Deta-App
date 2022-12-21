import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkText extends StatelessWidget {
  String link;
  LinkText({Key? key,required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(link,style: Theme.of(context).textTheme.headline1,),
      onTap: ()async{
        if(link.contains(".")){
          bool l = await openBrowser(link);
          if(!l){
            bigSnakbar(context, ERROR, LAUNCH_ERR, "FALURE");
          }
        }
        return;
      },
    );
  }
}
Future<bool> openBrowser(String domainName) async{
  if(!domainName.contains("https://")){
    domainName = "https://$domainName";
  }
  Uri url = Uri.parse(domainName);

  if (await canLaunchUrl(url)) {
    await launchUrl(url,mode: LaunchMode.externalApplication);
    return true;
  }
  return false;
}
