import 'dart:io';

import 'package:deta/utils/HiveHelper.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:deta/assets/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:format/format.dart';
import 'package:intl/intl.dart';
import 'package:deta/models/RequestModel.dart';
import 'package:logger/logger.dart';


var logger = Logger();

GotoPage (BuildContext context,dynamic page) async {
  return await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => page));
}

void toaster(BuildContext context, msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Theme.of(context).primaryColorDark,
      fontSize: 16.0
  );
}

void snackBar(BuildContext context,String msg){
  final snackBar = SnackBar(
    content: Text(msg),
  );
 ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void bigSnakbar(context, String title, String message, String contTyp) {
  late ContentType contentType;
  switch(contTyp.toUpperCase()){
    case "SUCCESS":{contentType=ContentType.success;break;};
    case "FAILURE":{contentType=ContentType.failure;break;};
    case "WARNING":{contentType=ContentType.warning;break;};
    case "HELP":{contentType=ContentType.help;break;};
    default: contentType= ContentType.success;
  }
  var snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void copy2Clipboard(context,String txt) {
  Clipboard.setData(ClipboardData(text: txt));
  snackBar(context, CLIPBOARD_TXT.format(txt));
}

Future requester(Uri api, String method, String? body,Map<String, String>? headers) async {
  HttpClient httpClient = HttpClient();
  late HttpClientRequest request;
  switch (method) {
    case "GET":
      {
        request = await httpClient.getUrl(api);
        break;
      }
    case "POST":
      {
        request = await httpClient.postUrl(api);
        break;
      }
    case "DELETE":
      {
        request = await httpClient.deleteUrl(api);
        break;
      }
    case "PATCH":
      {
        request = await httpClient.patchUrl(api);
        break;
      }
  }
  if(headers!= null) {
    for (String key in headers.keys) {
      request.headers.set(key, headers[key]!);
    }
  }
  if (body != null) {
    request.add(utf8.encode(body));
  }
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  return [response.statusCode, strToJson(reply)];
}


int currentTimestamp(){
  return ((DateTime.now().microsecondsSinceEpoch) / 1000000).round();
}
RequestModel reqModel(String m, String u, {String? body}) {
  RequestModel req;
  String ts = currentTimestamp().toString();

  String contentType = "";
  if (body != null) {
    contentType = "application/json";
  }

  req = RequestModel(m, u, ts, contentType, (body));
  return req;
}





// Future encryptCont(dynamic plainText)async{
//   final key = encryptMod.Key.fromUtf8(dotenv.env[CACHE_KEY]!);
//   final iv = encryptMod.IV.fromLength(16);
//   final encrypter = encryptMod.Encrypter(encryptMod.AES(key));
//   final rd =  encrypter.encrypt(plainText, iv: iv).base64;
//   return rd;
// }
//
// Future decryptCont(dynamic encryptedTxt) async{
//   final key = encryptMod.Key.fromUtf8(dotenv.env[CACHE_KEY]!);
//   final iv = encryptMod.IV.fromLength(16);
//   final encrypter = encryptMod.Encrypter(encryptMod.AES(key));
//   final rd = encrypter.decrypt(encryptMod.Encrypted.from64(encryptedTxt), iv: iv);
//   return rd;
// }


// final cache = FFCache();

// Future<bool> cacheExists(String keyname) async {
//   await cache.init();
//   if (await cache.has(keyname)) {
//     return true;
//   }
//   return false;
// }

// void setCache(String keyname, dynamic data) async {
//   if (await cacheExists(keyname)) {
//     await cache.remove(keyname);
//   }
//   String setData = await encryptCont(json.encode(data));
//   await cache.setJSONWithTimeout(keyname, setData, Duration(minutes: 30));
// }
//
// Future getCache(String keyname) async {
//   if (await cacheExists(keyname)) {
//     var cacheData = await cache.getJSON(keyname);
//     cacheData = await decryptCont(cacheData);
//     return json.decode(cacheData);
//   }
//   return [];
// }

// APICacheManager cache = APICacheManager();
// Future<bool> cacheExists(String keyname) async {
//   // await cache.init();
//   if (await cache.isAPICacheKeyExist(keyname)) {
//     return true;
//   }
//   return false;
// }


// void setCache(String keyname, dynamic data) async {
//
//   if (await cacheExists(keyname)) {
//     await cache.deleteCache(keyname);
//   }
//   data = json.encode(data);
//   // String setData = await encryptCont(json.encode(data));
//   // await cache.setJSONWithTimeout(keyname, setData, Duration(minutes: 30));
//   APICacheDBModel model = APICacheDBModel(key: keyname, syncData: data);
//   await cache.addCacheData(model);
// }
//
// Future getCache(String keyname) async {
//   if (await cacheExists(keyname)) {
//     var cacheData = await cache.getCacheData(keyname);
//     var cacheData2 = json.decode(cacheData.syncData);
//     // cacheData = await decryptCont(cacheData2);
//     // print(cacheData);
//     // cacheData2 = json.decode(cacheData.syncData);
//     return (cacheData2);
//   }
//   return [];
// }

jsonToString(dynamic value){
  return value==null?value:json.encode(value);
}

strToJson(dynamic value){
  return value==null?value:json.decode(value);
}


// DateFormat dateformatter = DateFormat('yMMMd HH:mm:ss');
String formatDate(dynamic dt,{String? dateformat}){
  if(dt==null){
    return "null";
  }
  dateformat ??= 'y-M-d HH:mm:ss';

  DateFormat dateformatter = DateFormat(dateformat);
  late DateTime fdt;
  if(dt.toString().contains("UTC")){
    fdt = dateformatter.parse(dt,true);
  }
  else {
    // int mirots = int.parse(dt.toString())*1000000;
    fdt = DateTime.parse(dt);
  }
  return dateformatter.format(fdt);
}

String dateDifference(dynamic endDate){
  DateTime sdt = DateTime.now();
  DateTime edt = DateTime.parse(endDate);

  Duration diff = edt.difference(sdt);
  int diffDays = diff.inDays;

  if(diff.isNegative || diffDays<0){
    return "Expired";
  }
  return "$diffDays Days";
}

Future checkInternet()async{
    return true;
}

Future<bool> APIFetch(String uri)async{
  int ts = currentTimestamp();
  bool rd = true;// yes fetch from API
  CacheTimeDB cacheTimeDB = CacheTimeDB();
  var lastfetch = await cacheTimeDB.get(uri);

  if(lastfetch!=null){
    int diff =ts-int.parse(lastfetch.toString());
    if(diff<CACHE_TIME){//if diff between current ts and fetch is less than 90sec return false else return true
      rd = false;
    }
  }
  if(rd) {
    //save only if data is fetched
    await cacheTimeDB.set(uri, ts.toString());
  }
  // print("APIFetch : $rd");
  return rd;
}
