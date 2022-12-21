import 'dart:ffi';

import 'package:deta/assets/Constants.dart';
import 'package:deta/models/AccessTokenModel.dart';
import 'package:deta/models/MicroModel.dart';
import 'package:deta/models/ProgramModel.dart';
import 'package:deta/models/ProjectTokenModel.dart';
import 'package:deta/utils/Boxes.dart';
import 'package:deta/models/UserModel.dart';
import 'package:deta/models/ProjectModel.dart';
import 'package:deta/models/UserAccessTokenModel.dart';
import 'package:deta/utils/Additonal.dart';

class UserDB {
  UserModel userModel;

  UserDB({required this.userModel});

  Future addUser({bool upd = false}) async {
    try {
      Boxes box = Boxes(boxName: BOX_USER, encryption: true);
      String key = userModel.spaceId.toString();

      var val = jsonToString(userModel.toJson());
      bool cond = await box.put(key, val);
      if (cond) {
        return 1;
      } else {
        return 0;
      }

      if (upd) {
        return 1;
      }
      return 2;
    } catch (e, s) {
      //print(s);
      return 0;
    }
  }

  Future<List> getAllUser() async {
    var rd = [];
    try {
      Boxes box = Boxes(boxName: BOX_USER, encryption: true);
      var data = await box.getAll();

      for (var item in data) {
        item = strToJson(item);
        UserModel dummy = UserModel.fromJson(item);
        rd.add(dummy);
      }
      return rd;
    } catch (e, s) {
      //print(e);
    }
    return [];
  }
}

class ProjectDB {
  UserModel userModel;
  ProjectDB({required this.userModel});

  Future<List> getAll() async {
    var rd = null;

    String boxName = userModel.spaceId.toString();
    Boxes box = Boxes(boxName: boxName, encryption: false);
    try {
      rd = [];

      var data = await box.get(BOX_PROJECTS);
      if (data != null) {
        // data = strToJson(data);
        rd = List.generate(
            data.length, (index) => ProjectModel.fromJson(data[index]));
        // for (var item in data) {
        //   ProjectModel dummy = ProjectModel.fromJson(item);
        //   rd.add(dummy);
        // }
      }
      return rd;
    } catch (e, s) {
      //print(s);
      return rd;
    }
    return rd;
  }

  Future put(dynamic data) async {
    String boxName = userModel.spaceId.toString();
    Boxes box = Boxes(boxName: boxName, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(BOX_PROJECTS, val);
      return cond;
    } catch (e, s) {
      //print(s);
    }
    return false;
  }
}

class UserAccessTokenDB {
  UserModel userModel;
  UserAccessTokenDB({required this.userModel});

  //hive to return
  Future<List> getAll() async {
    var rd = null;

    String boxName = userModel.spaceId.toString();
    Boxes box = Boxes(boxName: boxName, encryption: false);
    try {
      rd = [];

      var data = await box.get(BOX_ACCESS_TOKEN);
      if (data != null) {
        // data = strToJson(data);
        // rd = List.generate(
        //     data.length, (index) => UserAccessTokenModel.fromJson(data[index]));
        for (var item in data) {
          UserAccessTokenModel dummy = UserAccessTokenModel.fromJson(item);
          rd.add(dummy);
        }
      }
      return rd;
    } catch (e, s) {
      //print(e);
      return rd;
    }
    return rd;
  }

  //api to hive
  Future put(dynamic data) async {
    String boxName = userModel.spaceId.toString();
    Boxes box = Boxes(boxName: boxName, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(BOX_ACCESS_TOKEN, val);
      return cond;
    } catch (e, s) {
      //print(s);
    }
    return false;
  }

  //user token list
  Future getTokenList() async {
    String boxName = userModel.spaceId.toString();
    Boxes box = Boxes(boxName: boxName, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN);
      return cacheData;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //user token key list
  Future getKeyList() async {
    Boxes box = Boxes(boxName: BOX_UA_TOKEN_KEY, encryption: true);
    try {
      String spaceId = userModel.spaceId.toString();
      var cacheData = await box.get(spaceId);
      return cacheData;
      // return strToJson(cacheData);
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //key key from usertoken model
  Future<UserAccessTokenModel> getKey(
      UserAccessTokenModel userAccessTokenModel) async {
    String accessTokenId = userAccessTokenModel.accessKeyId.toString();

    var accessTokenList = await getKeyList();

    if (accessTokenList != null) {
      if (accessTokenList.length != 0) {
        for (var item in accessTokenList) {
          // logger.i(item);
          item = AccessTokenModel.fromJson(item);

          if (item.id != accessTokenId) {
            continue;
          }
          userAccessTokenModel.accessToken = item.key.toString();
          break;
        }
      }
    }
    return userAccessTokenModel;
  }

  //del ky and return the exlist
  Future<List> delKey(String tokenId) async{
    List exkeyList = await getKeyList();

    exkeyList ??= []; //if null the []
    try {
      for (int i = 0; i < exkeyList.length; i++) {
        AccessTokenModel exkey = AccessTokenModel.fromJson(exkeyList[i]);
        if (exkey.id == tokenId) {

          exkeyList.removeAt(i);
          Boxes box = Boxes(boxName: BOX_UA_TOKEN_KEY, encryption: true);
          String spaceId = userModel.spaceId.toString();
          box.put(spaceId, jsonToString(exkeyList));
          break;
        }
      }

    } catch (e) {
      //print(e);
    }
    return exkeyList;
  }

  //insert & save key
  Future<bool> putKey(UserAccessTokenModel userAccessTokenModel) async {
    try {
      AccessTokenModel accessTokenModel = AccessTokenModel(
          id: userAccessTokenModel.accessKeyId,
          key: userAccessTokenModel.accessToken);

      Boxes box = Boxes(boxName: BOX_UA_TOKEN_KEY, encryption: true);

      String spaceId = userModel.spaceId.toString();

      List exkeyList = await delKey(accessTokenModel.id.toString());
      var jsonData = accessTokenModel.toJson();
      exkeyList.add(jsonData);
      box.put(spaceId, jsonToString(exkeyList));

      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //delete key
  Future<bool> deleteKey(String tokenId) async {
    bool rd = false;
    try {
      List exkeyList = await delKey(tokenId);
      return true;

    } catch (e) {
      //print(e);
    }
    return rd;
  }
}

class MicroDB {
  UserModel userModel;
  String project_id;
  MicroDB({required this.userModel, required this.project_id});

  //hive to return
  Future<List> getAll() async {
    var rd = null;

    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      rd = [];

      var data = await box.get(BOX_MICRO);
      if (data != null) {
        // data = strToJson(data);
        // rd = List.generate(
        //     data.length, (index) => UserAccessTokenModel.fromJson(data[index]));
        for (var item in data) {
          ProgramModel dummy = ProgramModel.fromJson(item);
          rd.add(dummy);
        }
      }
      return rd;
    } catch (e, s) {
      //print(s);
      return rd;
    }
    return rd;
  }

  //api to hive
  Future put(dynamic data) async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(BOX_MICRO, val);
      return cond;
    } catch (e, s) {
      //print(s);
    }
    return false;
  }

  //user token list
  Future getTokenList() async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN);
      return cacheData;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //user token key list
  Future getKeyList() async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN_KEY);
      return cacheData;
      // return strToJson(cacheData);
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //key key from usertoken model
  Future<UserAccessTokenModel> getKey(
      UserAccessTokenModel userAccessTokenModel) async {
    var accessTokenList = await getKeyList();
    if (accessTokenList != null) {
      if (accessTokenList.length != 0) {
        for (var item in accessTokenList) {
          item = AccessTokenModel.fromJson(item);

          if (item.id != userAccessTokenModel.accessKeyId) {
            continue;
          }
          userAccessTokenModel.accessToken = item.key.toString();
          break;
        }
      }
    }
    return userAccessTokenModel;
  }

  //insert key
  Future<bool> putKey(UserAccessTokenModel userAccessTokenModel) async {
    try {
      // List userAccessTokenModelList = [];
      // List accessTokenModelList = [];

      AccessTokenModel accessTokenModel = AccessTokenModel(
          id: userAccessTokenModel.accessKeyId,
          key: userAccessTokenModel.accessToken);

      List exkeyList = await getKeyList();
      // List extokenList = await getTokenList();
      exkeyList ??= [];
      // if (extokenList != null) {
      //   extokenList= [];
      // }
      exkeyList.add(accessTokenModel.toJson()); //stores the key in json format

      Boxes box = Boxes(boxName: project_id, encryption: false);
      box.put(BOX_ACCESS_TOKEN_KEY, jsonToString(exkeyList));

      // extokenList.add(userAccessTokenModel.toJson());
      // box.put(BOX_USER_ACCESS_TOKEN, jsonToStr(extokenList));
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //delete key
  Future<bool> deleteKey(String tokenId) async {
    try {
      // List userAccessTokenModelList = [];
      // List accessTokenModelList = [];

      List exkeyList = await getKeyList();
      // List extokenList = await getTokenList();
      exkeyList ??= []; //if null the []
      // if (extokenList != null) {
      //   extokenList= [];
      // }
      var data = exkeyList.where((rec) => (rec["id"].contains(tokenId)));
      if (data != null) {
        exkeyList.remove(data); //stores the key in json format

        Boxes box = Boxes(boxName: project_id, encryption: false);
        box.put(BOX_ACCESS_TOKEN_KEY, jsonToString(exkeyList));

        // extokenList.add(userAccessTokenModel.toJson());
        // box.put(BOX_USER_ACCESS_TOKEN, jsonToStr(extokenList));
        return true;
      }
      return false;
    } catch (e) {
      //print(e);
      return false;
    }
  }
}

class BasesDB {
  UserModel userModel;
  String project_id;
  BasesDB({required this.userModel, required this.project_id});

  //hive to return
  Future<List> getAll() async {
    var rd = null;

    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      rd = [];

      var data = await box.get(BOX_BASES);
      if (data != null) {
        // data = strToJson(data);
        // rd = List.generate(
        //     data.length, (index) => UserAccessTokenModel.fromJson(data[index]));
        rd = data;
      }
      return rd;
    } catch (e, s) {
      //print(s);
      return rd;
    }
    return rd;
  }

  //api to hive
  Future put(dynamic data) async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(BOX_BASES, val);
      return cond;
    } catch (e, s) {
      //print(s);
    }
    return false;
  }

  //user token list
  Future getTokenList() async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN);
      return cacheData;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //user token key list
  Future getKeyList() async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN_KEY);
      return cacheData;
      // return strToJson(cacheData);
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //key key from usertoken model
  Future<UserAccessTokenModel> getKey(
      UserAccessTokenModel userAccessTokenModel) async {
    var accessTokenList = await getKeyList();
    if (accessTokenList != null) {
      if (accessTokenList.length != 0) {
        for (var item in accessTokenList) {
          item = AccessTokenModel.fromJson(item);

          if (item.id != userAccessTokenModel.accessKeyId) {
            continue;
          }
          userAccessTokenModel.accessToken = item.key.toString();
          break;
        }
      }
    }
    return userAccessTokenModel;
  }

  //insert key
  Future<bool> putKey(UserAccessTokenModel userAccessTokenModel) async {
    try {
      // List userAccessTokenModelList = [];
      // List accessTokenModelList = [];

      AccessTokenModel accessTokenModel = AccessTokenModel(
          id: userAccessTokenModel.accessKeyId,
          key: userAccessTokenModel.accessToken);

      List exkeyList = await getKeyList();
      // List extokenList = await getTokenList();
      exkeyList ??= [];
      // if (extokenList != null) {
      //   extokenList= [];
      // }
      exkeyList.add(accessTokenModel.toJson()); //stores the key in json format

      Boxes box = Boxes(boxName: project_id, encryption: false);
      box.put(BOX_ACCESS_TOKEN_KEY, jsonToString(exkeyList));

      // extokenList.add(userAccessTokenModel.toJson());
      // box.put(BOX_USER_ACCESS_TOKEN, jsonToStr(extokenList));
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //delete key
  Future<bool> deleteKey(String tokenId) async {
    try {
      // List userAccessTokenModelList = [];
      // List accessTokenModelList = [];

      List exkeyList = await getKeyList();
      // List extokenList = await getTokenList();
      exkeyList ??= []; //if null the []
      // if (extokenList != null) {
      //   extokenList= [];
      // }
      var data = exkeyList.where((rec) => (rec["id"].contains(tokenId)));
      if (data != null) {
        exkeyList.remove(data); //stores the key in json format

        Boxes box = Boxes(boxName: project_id, encryption: false);
        box.put(BOX_ACCESS_TOKEN_KEY, jsonToString(exkeyList));

        // extokenList.add(userAccessTokenModel.toJson());
        // box.put(BOX_USER_ACCESS_TOKEN, jsonToStr(extokenList));
        return true;
      }
      return false;
    } catch (e) {
      //print(e);
      return false;
    }
  }
}

class ProjectTokenDB {
  UserModel userModel;
  String project_id;
  ProjectTokenDB({required this.userModel, required this.project_id});

  //hive to return
  Future<List> getAll() async {
    var rd = null;

    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      rd = [];

      var data = await box.get(BOX_ACCESS_TOKEN);
      if (data != null) {
        for (var item in data) {
          ProjectTokenModel dummy = ProjectTokenModel.fromJson(item);
          rd.add(dummy);
        }
      }
      return rd;
    } catch (e, s) {
      //print(e);
      return rd;
    }
    return rd;
  }

  //api to hive
  Future put(dynamic data) async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(BOX_ACCESS_TOKEN, val);
      return cond;
    } catch (e, s) {
      //print(s);
    }
    return false;
  }

  //user token list
  Future getTokenList() async {
    Boxes box = Boxes(boxName: project_id, encryption: false);
    try {
      var cacheData = await box.get(BOX_ACCESS_TOKEN);
      return cacheData;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //user token key list
  Future getKeyList() async {
    Boxes box = Boxes(boxName: BOX_PROJECT_TOKEN_KEY, encryption: true);
    try {
      var cacheData = await box.get(project_id);
      return cacheData;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //key key from usertoken model
  Future<ProjectTokenModel> getKey(ProjectTokenModel projectTokenModel) async {
    var accessTokenList = await getKeyList();
    if (accessTokenList != null) {
      if (accessTokenList.length != 0) {
        for (var item in accessTokenList) {
          item = AccessTokenModel.fromJson(item);
          if (item.id != projectTokenModel.name) {
            continue;
          }
          projectTokenModel.accessToken = item.key.toString();
          break;
        }
      }
    }
    return projectTokenModel;
  }

  //insert key
  Future<bool> putKey2(ProjectTokenModel projectTokenModel) async {
    try {
      AccessTokenModel accessTokenModel = AccessTokenModel(
          id: projectTokenModel.name, key: projectTokenModel.accessToken);

      List exkeyList = await getKeyList();
      exkeyList ??= [];
      exkeyList.add(accessTokenModel.toJson()); //stores the key in json format

      Boxes box = Boxes(boxName: BOX_PROJECT_TOKEN_KEY, encryption: false);
      box.put(project_id, jsonToString(exkeyList));
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //delete key
  Future<bool> deleteKey2(String tokenId) async {
    try {
      List exkeyList = await getKeyList();

      exkeyList ??= []; //if null the []

      var data = exkeyList.where((rec) => (rec["id"].contains(tokenId)));
      if (data != null) {
        exkeyList.remove(data); //stores the key in json format

        Boxes box = Boxes(boxName: BOX_PROJECT_TOKEN_KEY, encryption: false);
        box.put(project_id, jsonToString(exkeyList));
        return true;
      }
      return false;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //del ky and return the exlist
  Future<List> delKey(String tokenId) async{
    List exkeyList = await getKeyList();
    exkeyList ??= []; //if null the []
    try {
      for (int i = 0; i < exkeyList.length; i++) {
        AccessTokenModel exkey = AccessTokenModel.fromJson(exkeyList[i]);
        if (exkey.id == tokenId) {

          exkeyList.removeAt(i);
          Boxes box = Boxes(boxName: BOX_PROJECT_TOKEN_KEY, encryption: false);
          // String spaceId = userModel.spaceId.toString();
          box.put(project_id, jsonToString(exkeyList));
          break;
        }
      }

    } catch (e) {
      //print(e);
    }
    return exkeyList;
  }

  //insert & save key
  Future<bool> putKey(ProjectTokenModel projectTokenModel) async {
    try {
      AccessTokenModel accessTokenModel = AccessTokenModel(
          id: projectTokenModel.name, key: projectTokenModel.accessToken);

      Boxes box = Boxes(boxName: BOX_PROJECT_TOKEN_KEY, encryption: true);

      List exkeyList = await delKey(accessTokenModel.id.toString());
      var jsonData = accessTokenModel.toJson();
      exkeyList.add(jsonData);
      box.put(project_id, jsonToString(exkeyList));

      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }

  //delete key
  Future<bool> deleteKey(String tokenId) async {
    bool rd = false;
    try {
      List exkeyList = await delKey(tokenId);
      return true;

    } catch (e) {
      //print(e);
    }
    return rd;
  }
}

class MicroDetailsDB {
  //hive to return
  Future get(String micro_id) async {
    var rd = null;

    Boxes box = Boxes(boxName: BOX_MICRO, encryption: false);
    try {
      var data = await box.get(micro_id);
      if (data != null) {
        // data = strToJson(data);
        // rd = List.generate(
        //     data.length, (index) => UserAccessTokenModel.fromJson(data[index]));

        return MicroModel.fromJson(data);
      }
      return rd;
    } catch (e, s) {
      //print(s);
      return rd;
    }
    return rd;
  }

  //api to hive
  Future put(String micro_id, dynamic data) async {
    Boxes box = Boxes(boxName: BOX_MICRO, encryption: false);
    try {
      var val = jsonToString(data);
      bool cond = await box.put(micro_id, val);
      return cond;
    } catch (e, s) {
      //print(e);
    }
    return false;
  }

  //delete key
  Future<bool> deleteKey(String micro_id) async {
    try {
      Boxes box = Boxes(boxName: BOX_MICRO, encryption: false);
      box.delete(micro_id);

      // extokenList.add(userAccessTokenModel.toJson());
      // box.put(BOX_USER_ACCESS_TOKEN, jsonToStr(extokenList));
      return true;
    } catch (e) {
      //print(e);
      return false;
    }
  }
}

class CacheTimeDB {
  Boxes boxes = Boxes(boxName: BOX_CACHE_TIME, encryption: false);
  Future get(String key) async {
    return await boxes.get(key);
  }

  Future set(String key, String val) async {
    return await boxes.put(key, val);
  }
}

class UpdateDB {
  Boxes boxes = Boxes(boxName: BOX_UPD_INFO, encryption: false);
  Future get(String key) async {
    return await boxes.get(key);
  }

  Future set(String key, String val) async {
    return await boxes.put(key, val);
  }
}