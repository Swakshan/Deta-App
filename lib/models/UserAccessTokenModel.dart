import 'package:hive/hive.dart';


class UserAccessTokenModel{
  String? _accessKeyId;
  String? _created;
  String? _expires;
  bool? _active;
  String? _accessToken;

  UserAccessTokenModel(
      {required String? accessKeyId,
      required String? created,
      required String? expires,
      required bool? active,
      String? accessToken}) {
    if (accessKeyId != null) {
      this._accessKeyId = accessKeyId;
    }
    if (created != null) {
      this._created = created;
    }
    if (expires != null) {
      this._expires = expires;
    }
    if (active != null) {
      this._active = active;
    }
    if (accessToken != null) {
      this._accessToken = accessToken;
    }
  }

  String? get accessKeyId => _accessKeyId;
  set accessKeyId(String? accessKeyId) => _accessKeyId = accessKeyId;
  String? get created => _created;
  set created(String? created) => _created = created;
  String? get expires => _expires;
  set expires(String? expires) => _expires = expires;
  bool? get active => _active;
  set active(bool? active) => _active = active;
  String? get accessToken => _accessToken;
  set accessToken(String? accessToken) => _accessToken = accessToken;

  UserAccessTokenModel.fromJson(Map<String, dynamic> json) {
    _accessKeyId = json['access_key_id'];
    _created = json['created'];
    _expires = json['expires'];
    _active = json['active'];
    _accessToken = json['access_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_key_id'] = this._accessKeyId;
    data['created'] = this._created;
    data['expires'] = this._expires;
    data['active'] = this._active;
    data['access_token'] = this._accessToken;
    return data;
  }
}

