import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  final storage = new FlutterSecureStorage();

  Future getValue(String keyName) async {
    try {
      return await storage.read(key: keyName);
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<int> getNum(String keyName) async {
    try {
      String? val = await storage.read(key: keyName);
      if(val!=null){
        return int.parse(val);
      }
      return 0;
    } catch (e) {
      // print(e);
      return 0;
    }
  }

  Future<bool> setValue(String keyName, String val) async {
    try {
      await storage.write(key: keyName, value: val);
      return true;
    } catch (e) {
      return false;
    }
  }

  createKey(dynamic key)async{
    await storage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }

  Future getKey()async{
    String? b64Key =  await getValue('key');
    if(b64Key!=null){
      return base64Url.decode(b64Key!);
    }
    return null;
  }

}
