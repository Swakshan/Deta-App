import 'package:deta/assets/Constants.dart';
import 'package:deta/models/UpdateModel.dart';
import 'package:deta/utils/APIService.dart';
import 'package:deta/widgets/UpdateDialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future versionChecker()async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String exVersion ="${ packageInfo.version}(${packageInfo.buildNumber})";
  MyAPI myAPI = MyAPI();
  UpdateModel? updateModel =  await myAPI.latestVersion();

  if(updateModel==null){
    return null;
  }
  String? newVersion = updateModel.version;
  if(newVersion!=exVersion){
    return updateModel;
  }
  return null;
}

Future specificVersion()async{
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String exVersion ="${ packageInfo.version}(${packageInfo.buildNumber})";
  MyAPI myAPI = MyAPI();
  UpdateModel? updateModel =  await myAPI.specificVersion(exVersion);
  if(updateModel==null){
    return null;
  }
  return updateModel;
}


Future checkVersion(BuildContext context,bool changeLogs)async{
  late UpdateModel? updateModel;
  late String title;
  if(changeLogs){
    updateModel = await specificVersion();
    title = CHANGELOGS_TXT;
  }
  else{
    updateModel = await versionChecker();
    title = NEW_UPDATE;
  }

  if(updateModel!=null){

    final action = await UpdDialog.AlertBox(
      context,
      title,
      updateModel,
    );
    return true;
  }
  return false;
}