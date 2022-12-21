class MicroStatusModel {
  Tests? tests;
  String? service;
  String? region;
  int? timestamp;
  double? duration;

  MicroStatusModel(
      {this.tests, this.service, this.region, this.timestamp, this.duration});

  MicroStatusModel.fromJson(Map<String, dynamic> json) {
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
  Ping? ping;

  Tests({this.ping});

  Tests.fromJson(Map<String, dynamic> json) {
    ping = json['ping'] != null ? new Ping.fromJson(json['ping']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ping != null) {
      data['ping'] = this.ping!.toJson();
    }
    return data;
  }
}

class Ping {
  String? name;
  bool? passed;
  double? duration;
  Details? details;

  Ping({this.name, this.passed, this.duration, this.details});

  Ping.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    passed = json['passed'];
    duration = json['duration'];
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
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

  Details({this.averageResponseTime, this.responseTimes});

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
