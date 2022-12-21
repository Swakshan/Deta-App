class BaseStatusModel {
  Tests? tests;
  String? service;
  String? region;
  int? timestamp;
  double? duration;

  BaseStatusModel({this.tests, this.service, this.region, this.timestamp, this.duration});

  BaseStatusModel.fromJson(Map<String, dynamic> json) {
    tests = json['tests'] != null ? new Tests.fromJson(json['tests']) : null;
    service = json['service'];
    region = json['region'];
    timestamp = json['timestamp'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tests != null) {
      data['tests'] = this.tests!.toJson();
    }
    data['service'] = this.service;
    data['region'] = this.region;
    data['timestamp'] = this.timestamp;
    data['duration'] = this.duration;
    return data;
  }
}

class Tests {
  Delete? delete;
  Delete? fetch;
  Delete? get;
  Delete? insert;
  Delete? ping;
  Delete? put;
  Delete? update;

  Tests({this.delete, this.fetch, this.get, this.insert, this.ping, this.put, this.update});

  Tests.fromJson(Map<String, dynamic> json) {
    delete = json['delete'] != null ? new Delete.fromJson(json['delete']) : null;
    fetch = json['fetch'] != null ? new Delete.fromJson(json['fetch']) : null;
    get = json['get'] != null ? new Delete.fromJson(json['get']) : null;
    insert = json['insert'] != null ? new Delete.fromJson(json['insert']) : null;
    ping = json['ping'] != null ? new Delete.fromJson(json['ping']) : null;
    put = json['put'] != null ? new Delete.fromJson(json['put']) : null;
    update = json['update'] != null ? new Delete.fromJson(json['update']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.delete != null) {
      data['delete'] = this.delete!.toJson();
    }
    if (this.fetch != null) {
      data['fetch'] = this.fetch!.toJson();
    }
    if (this.get != null) {
      data['get'] = this.get!.toJson();
    }
    if (this.insert != null) {
      data['insert'] = this.insert!.toJson();
    }
    if (this.ping != null) {
      data['ping'] = this.ping!.toJson();
    }
    if (this.put != null) {
      data['put'] = this.put!.toJson();
    }
    if (this.update != null) {
      data['update'] = this.update!.toJson();
    }
    return data;
  }
}

class Delete {
  String? name;
  bool? passed;
  double? duration;
  Details? details;

  Delete({this.name, this.passed, this.duration, this.details});

  Delete.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    passed = json['passed'];
    duration = json['duration'];
    details = json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['passed'] = this.passed;
    data['duration'] = this.duration;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Details {
  double? averageResponseTime;
  List<double>? responseTimes;

  Details(){}
  Details.namedConstructor({this.averageResponseTime, this.responseTimes});

  Details.fromJson(Map<String, dynamic> json) {
    averageResponseTime = json['average_response_time'];
    responseTimes = json['response_times'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_response_time'] = this.averageResponseTime;
    data['response_times'] = this.responseTimes;
    return data;
  }
}
