class UpdateModel {
  String? _version;
  String? _date;
  List<String>? _changelogs;
  String? _link;

  UpdateModel({String? version, String? date, List<String>? changelogs, String? link}) {
    if (version != null) {
      this._version = version;
    }
    if (date != null) {
      this._date = date;
    }
    if (changelogs != null) {
      this._changelogs = changelogs;
    }
    if (link != null) {
      this._link = link;
    }
  }

  String? get version => _version;
  set version(String? version) => _version = version;
  String? get date => _date;
  set date(String? date) => _date = date;
  List<String>? get changelogs => _changelogs;
  set changelogs(List<String>? changelogs) => _changelogs = changelogs;
  String? get link => _link;
  set link(String? link) => _link = link;

  UpdateModel.fromJson(Map<String, dynamic> json) {
    _version = json['version'];
    _date = json['date'];
    _changelogs = [];
    if (json['changelogs'] != null) {
      json['changelogs'].forEach((v) { _changelogs!.add(v); });
    }
    _link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this._version;
    data['date'] = this._date;
    data['changelogs'] = <List>[];
    if (this._changelogs != null) {
      data['changelogs'] = this._changelogs!.map((v) => v).toList();
    }
    data['link'] = this._link;
    return data;
  }
}

