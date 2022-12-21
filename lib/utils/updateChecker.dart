import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UpdateModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/widgets/UpdateDialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future versionChecker(bool fromAPI)async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String exVersion ="${ packageInfo.version}(${packageInfo.buildNumber})";
  MyAPI myAPI = MyAPI();
  UpdateModel? updateModel =  await myAPI.latestVersion(fromAPI);
  if(updateModel==null){
    return null;
  }
  String? newVersion = updateModel.version;
  if(newVersion!=exVersion || !fromAPI){
    return updateModel;
  }
  return null;
}

Future checkVersion(BuildContext context,bool fromAPI)async{
  UpdateModel? updateModel = await versionChecker(fromAPI);
  if(updateModel!=null){
    String title = NEW_UPDATE;
    if(!fromAPI){
      title = CHANGELOGS_TXT;
    }
    final action = await UpdDialog.AlertBox(
      context,
      title,
      updateModel,
    );
    return true;
  }
  return false;
}