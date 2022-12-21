import 'package:deta/assets/Constants.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/utils/LocalStorage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Boxes {
 String boxName;
 bool encryption;
 Boxes({required this.encryption,required this.boxName});

 Future boxKey()async{
   LocalStorage localStorage = LocalStorage();
   final encryptionKey = await localStorage.getKey();
   if (encryptionKey == null) {
     var key = Hive.generateSecureKey();
     localStorage.createKey(key);
     return key;
   }
   return encryptionKey;
 }


  Future<Box> openBox(String cond)async {
    //print("$cond opens $boxName");
    var encryptionCipher = null;
    if(encryption) {
      var encKey = await boxKey();
      encryptionCipher = HiveAesCipher(encKey);
    }
    return await Hive.openBox(
        boxName, encryptionCipher: encryptionCipher);
  }

  Future closeBox(String cond)async{
    //print("$cond closes $boxName");
    var bx = Hive.box(boxName);
    // //print('$boxName is ${bx.isOpen}');
      if(bx.isOpen) {
        return await bx.close();
      }

  }

 Future get(String key)async {
   try {
     Box box = await openBox("get");
     var val = box.get(key);
     await closeBox("get");
     return strToJson(val);
   } catch (e, s) {
     //print(e);
     return null;
   }
 }

 Future<bool> put(String key, dynamic val)async{
    try {
      Box box = await openBox("put");
      if(Hive.isBoxOpen(boxName)) {
        box.put(key, val);

      }
      await closeBox("put");

      return true;
    } catch (e, s) {
      //print(e);
      return false;
    }
  }

 Future<bool> delete(String key)async{
   try {
     Box box = await openBox("del");
     box.delete(key);
     closeBox("del");
     return true;
   } catch (e, s) {
     //print(e);
     return false;
   }
 }

 Future getAll()async{
   try {
     Box box = await openBox("getall");
     var rd = box.values.toList();

     closeBox("getall");
     return rd;
   } catch (e, s) {
     //print(e);
     return [];
   }
 }
}

