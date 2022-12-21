import 'dart:io';
import 'dart:convert';
import 'package:deta/models/AccessTokenModel.dart';
import 'package:deta/models/MicroModel.dart';
import 'package:deta/models/MicroStatusModel.dart';
import 'package:deta/models/ProjectTokenModel.dart';
import 'package:deta/models/RequestModel.dart';
import 'package:deta/models/UserAccessTokenModel.dart';
import 'package:deta/models/UserModel.dart';
import 'package:deta/assets/Constants.dart';
import 'package:crypto/crypto.dart';
import 'package:deta/models/UpdateModel.dart';
import 'package:deta/utils/Additonal.dart';
import 'package:deta/utils/HiveHelper.dart';
import 'package:format/format.dart';

class DetaAPI {
  UserModel? userModel;

  DetaAPI({required this.userModel});

  Map<String, String> hashedHeader(RequestModel requestModel) {
    String message = requestModel.str();

    var tokenParts = userModel!.accessToken.split("_");
    String accessKeyID = tokenParts[0];
    String accessKeySecret = tokenParts[1];

    List<int> messageBytes = utf8.encode(message);
    List<int> key = utf8.encode(accessKeySecret);

    Hmac hmac = Hmac(sha256, key);
    Digest hexSign = hmac.convert(messageBytes);
    String sign = "v0=$accessKeyID:$hexSign";
    // //print(message);
    // logger.i(sign);
    Map<String, String> hdr = {};

    hdr[HDR_TIMESTAMP] = requestModel.timeStamp;
    hdr[HDR_SIGNATURE] = sign;
    if (message.contains(HDR_CONTENT_TYPE_STR)) {
      hdr[HDR_CONTENT_TYPE] = HDR_CONTENT_TYPE_STR;
    }
    return hdr;
  }

  Future request(String uri, String method, String? body) async {
    String accessToken = (userModel!.accessToken).toString();

    method = method.toUpperCase();
    RequestModel requestModel = reqModel(method, uri, body: body);
    Map<String, String> headers = hashedHeader(requestModel);

    var api = Uri.https(BASE_API_URL, uri);
    return requester(api, method, body, headers);
  }

  Future findUser() async {
    try {
      String method = "GET";
      String uri = SPACE_API_URI;
      List response = await request(uri, method, null);
      var data = response[1];
      if (response[0] ~/ 100 == 2) {
        data = data[0];
        data['spaceId'] = data['spaceID'];
        data['accessToken'] = userModel!.accessToken.toString();
        // logger.i(data);
        UserModel um = UserModel.fromJson(data);
        return um;
      } else {
        //print("key Creation error");
        //print(data);
        return null;
      }
    } on SocketException catch (e) {
      //print("No net");
    } catch (e) {
      //print(e);
    }
    return null;
  }

  //projects
  Future getProjects(forceRefresh) async {
    ProjectDB projectDB = ProjectDB(userModel: userModel!);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = PROJECT_API_URI.format(spaceId);

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);
        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var data = response[1];
          var rd = data['projects'];
          await projectDB.put(rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await projectDB.getAll();
  }

  Future<bool> createProject(String projectName, String regCode) async {
    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "POST";
      String? uri = PROJECT_API_URI.format(spaceId);
      String body = '{"name": "$projectName"}';
      if (regCode.isNotEmpty) {
        String body = '{"name": "$projectName", "region": "$regCode"}';
      }

      List response = await request(uri, method, body);
      var data = response[1];

      if (response[0] ~/ 100 == 2) {
        //print("from API");
        data = data['key'];
        ProjectTokenModel keyData = ProjectTokenModel.fromJson(data);
        ProjectTokenDB accessTokenDB = ProjectTokenDB(
            userModel: userModel!, project_id: keyData.projectId!);
        var cond = await accessTokenDB.putKey(keyData);
        return true;
      } else {}
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  //userToken
  Future getUserTokens(bool forceRefresh) async {
    UserAccessTokenDB accessTokenDB = UserAccessTokenDB(userModel: userModel!);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = USER_ACCESS_TOKEN_API_URI;

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);

        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var data = response[1];
          var rd = data['access_keys'];
          await accessTokenDB.put(rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await accessTokenDB.getAll();
  }

  Future createUserToken() async {
    UserAccessTokenDB accessTokenDB = UserAccessTokenDB(userModel: userModel!);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "POST";
      String? uri = USER_ACCESS_TOKEN_API_URI;

      List response = await request(uri, method, null);

      if (response[0] ~/ 100 == 2) {
        //print("from API");
        var data = response[1];
        var rd =
            await accessTokenDB.putKey(UserAccessTokenModel.fromJson(data));
        //print("key Creation success");
        return rd;
      } else {
        //print("key Creation error");
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future deleteUserToken(String token_id) async {
    UserAccessTokenDB accessTokenDB = UserAccessTokenDB(userModel: userModel!);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "DELETE";
      String? uri = "$USER_ACCESS_TOKEN_API_URI$token_id";

      List response = await request(uri, method, null);
      if (response[0] ~/ 100 == 2) {
        //print("from API");
        var data = response[1];
        var rd = await accessTokenDB.deleteKey(token_id);
        //print("key Creation success");
        return rd;
      } else {
        //print("key Creation error");
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future<UserAccessTokenModel> getUserTokenKey(
      UserAccessTokenModel userAccessTokenModel) async {
    UserAccessTokenDB userAccessTokenDB =
        UserAccessTokenDB(userModel: userModel!);
    return await userAccessTokenDB.getKey(userAccessTokenModel);
  }

  Future saveUserToken(UserAccessTokenModel userAccessTokenModel) async {
    UserAccessTokenDB userAccessTokenDB =
    UserAccessTokenDB(userModel: userModel!);
    return await userAccessTokenDB.putKey(userAccessTokenModel);
  }


  //micro
  Future getMicros(String project_id, bool forceRefresh) async {
    MicroDB microDB = MicroDB(userModel: userModel!, project_id: project_id);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = MICRO_URI.format(spaceId, project_id);

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);

        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var rd = response[1];
          await microDB.put(rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await microDB.getAll();
  }

  Future<bool> deleteMicro(String micro_id) async {
    try {
      String method = "DELETE";
      String? uri = MICRO_DETAIL_URI.format(micro_id);

      List response = await request(uri, method, null);
      var data = response[1];
      if (response[0] ~/ 100 == 2) {
        return true;
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future getMicroDetail(String micro_id, bool forceRefresh) async {
    MicroDetailsDB microDB = MicroDetailsDB();

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = MICRO_DETAIL_URI.format(micro_id);

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);

        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var rd = response[1];

          await microDB.put(micro_id, rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await microDB.get(micro_id);
  }

  //bases
  Future getBases(String project_id, bool forceRefresh) async {
    BasesDB basesDB = BasesDB(userModel: userModel!, project_id: project_id);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = BASES_URI.format(spaceId, project_id);

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);

        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var rd = response[1];
          await basesDB.put(rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await basesDB.getAll();
  }

  //project keys
  Future getProjectTokens(String project_id, bool forceRefresh) async {
    ProjectTokenDB accessTokenDB =
        ProjectTokenDB(userModel: userModel!, project_id: project_id);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "GET";
      String? uri = PROJECT_KEYS_URI.format(project_id);

      if (await APIFetch(uri) || forceRefresh) {
        List response = await request(uri, method, null);
        if (response[0] ~/ 100 == 2) {
          //print("from API");
          var rd = response[1];

          await accessTokenDB.put(rd);
        } else {
          //print("from Cache");
        }
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return await accessTokenDB.getAll();
  }

  Future createProjectToken(String project_id, String name, String desp) async {
    int rd = 0;
    ProjectTokenDB accessTokenDB =
        ProjectTokenDB(userModel: userModel!, project_id: project_id);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "POST";
      String? uri = PROJECT_KEYS_URI.format(project_id);
      String body = '{"name": "$name", "description": "$desp"}';
      List response = await request(uri, method, body);
      var data = response[1];
      // logger.i(data);
      if (response[0] ~/ 100 == 2) {
        //print("from API");
        data = data['key'];
        var cond = await accessTokenDB.putKey(ProjectTokenModel.fromJson(data));
        //print("key Creation success");
        if (cond) {
          rd = 1;
        }
      } else {
        String error = data['errors'][0];
        if (error.contains("exists")) {
          rd = 2;
        }
        //print("key Creation error");
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return rd;
  }

  Future deleteProjectToken(String project_id, String token_id) async {
    UserAccessTokenDB accessTokenDB = UserAccessTokenDB(userModel: userModel!);

    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "DELETE";
      String? uri = PROJECT_KEYS_URI.format(project_id);
      uri = "$uri/$token_id";

      List response = await request(uri, method, null);

      if (response[0] ~/ 100 == 2) {
        //print("from API");
        var data = response[1];
        var rd = await accessTokenDB.deleteKey(token_id);
        //print("key Creation success");
        return rd;
      } else {
        //print("key Creation error");
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future<ProjectTokenModel> getProjectTokenKey(
      ProjectTokenModel projectTokenModel) async {
    ProjectTokenDB accessTokenDB = ProjectTokenDB(
        userModel: userModel!,
        project_id: projectTokenModel.projectId.toString());
    return await accessTokenDB.getKey(projectTokenModel);
  }

  Future saveProjectToken(ProjectTokenModel projectTokenModel) async {
    String project_id = projectTokenModel.projectId!;
    ProjectTokenDB projectTokenDB =
    ProjectTokenDB(userModel: userModel!,project_id: project_id);
    return await projectTokenDB.putKey(projectTokenModel);
  }

  //domains
  Future<bool> updateSubDomain(String program_id, String alias) async {
    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "PATCH";
      String? uri = SUBDOMAIN_URI.format(program_id);
      String body = '{"alias": "$alias"}';

      List response = await request(uri, method, body);

      if (response[0] ~/ 100 == 2) {
        //print("from API");
        return true;
      } else {
        //print(response[0]);
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future<List> createCusDomain(String program_id, String alias) async {
    String ip_address = ERROR;
    int statusCode = 4;
    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "POST";
      String? uri = CUSDOMAIN_URI.format(program_id);
      String body = '{"domain_name": "$alias"}';

      List response = await request(uri, method, body);
      statusCode = response[0] ~/ 100;
      var data = response[1];

      if (statusCode == 2) {
        ip_address = data['ip_address'];
      } else {
        ip_address = data['errors'][0];
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return [statusCode, ip_address];
  }

  Future<bool> deleteCusDomain(String program_id, String alias) async {
    try {
      String spaceId = (userModel!.spaceId).toString();
      String method = "DELETE";
      String? uri = CUSDOMAIN_URI.format(program_id);
      String body = '{"domains": ["$alias"]}';
      List response = await request(uri, method, body);
      int statusCode = response[0] ~/ 100;

      if (statusCode == 2) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }
    return false;
  }
}

class DetaStatusAPI {
  late String country;
  DetaStatusAPI({required this.country});

  Future? microStatus() async {
    try {
      String api = STATUS_MICRO.format(country);
      Uri uri = Uri.parse(api);
      var response = await requester(uri, "GET", null, null);
      int statusCode = response[0] ~/ 100;
      var data = response[1];
      var rd = List.generate(data.length,
          (index) => logger.i(MicroStatusModel.fromJson(data[index])));
      return rd;
    } catch (e) {
      //print(e);
    }

    return null;
  }

  Future? baseStatus() async {
    try {
      String api = STATUS_BASE.format(country);
      Uri uri = Uri.parse(api);
      var response = await requester(uri, "GET", null, null);
      int statusCode = response[0] ~/ 100;
      var data = response[1];
      logger.i(data.length);
    } on SocketException catch (e) {
      //print("No internet");
    } catch (e) {
      //print(e);
    }

    return null;
  }
}

class MyAPI {
  Future<UpdateModel?> latestVersion() async {
    UpdateDB updateDB = UpdateDB();
    try {

      String api = LATEST_UPD_URI;
      Uri uri = Uri.parse(api);
      var response = await requester(uri, "GET", null, null);
      int statusCode = response[0] ~/ 100;
      var data = response[1];
      if (statusCode == 2) {
        return UpdateModel.fromJson(data);
        // await updateDB.set(BOX_UPD_INFO, jsonToString(data));
      }

    } catch (e) {
      //print(e);
    }
    var data = await updateDB.get(BOX_UPD_INFO);
    return UpdateModel.fromJson(data);
  }

  Future<UpdateModel?> specificVersion(String version) async {
    UpdateDB updateDB = UpdateDB();
    try {
      var data = await updateDB.get(BOX_UPD_INFO);
      if(data!=null){
        return UpdateModel.fromJson(data);
      }
        String api = SPECIFIC_UPD_URI+version;
        Uri uri = Uri.parse(api);
        var response = await requester(uri, "GET", null, null);
        int statusCode = response[0] ~/ 100;
        data = response[1];
        if (statusCode == 2) {
          await updateDB.set(BOX_UPD_INFO, jsonToString(data));
        }

    } catch (e) {
      //print(e);
    }
    var data = await updateDB.get(BOX_UPD_INFO);
    return UpdateModel.fromJson(data);
  }
}
