class MicroModel {
  String? id;
  int? space;
  String? group;
  String? name;
  String? role;
  String? code;
  String? path;
  List<dynamic>? envs;
  List<dynamic>? deps;
  String? runtime;
  String? lib;
  String? account;
  String? region;
  int? memory;
  int? timeout;
  String? created;
  String? updated;
  bool? httpAuth;
  String? logLevel;
  bool? apiKey;
  String? forkedFrom;
  String? pathAlias;
  String? project;
  List<CustomDomains>? customDomains;

  MicroModel(
      {this.id,
        this.space,
        this.group,
        this.name,
        this.role,
        this.code,
        this.path,
        this.envs,
        this.deps,
        this.runtime,
        this.lib,
        this.account,
        this.region,
        this.memory,
        this.timeout,
        this.created,
        this.updated,
        this.httpAuth,
        this.logLevel,
        this.apiKey,
        this.forkedFrom,
        this.pathAlias,
        this.project,
        this.customDomains});

  MicroModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    space = json['space'];
    group = json['group'];
    name = json['name'];
    role = json['role'];
    code = json['code'];
    path = json['path'];
    envs = json['envs'];
    deps = json['deps'];
    runtime = json['runtime'];
    lib = json['lib'];
    account = json['account'];
    region = json['region'];
    memory = json['memory'];
    timeout = json['timeout'];
    created = json['created'];
    updated = json['updated'];
    httpAuth = json['http_auth'];
    logLevel = json['log_level'];
    apiKey = json['api_key'];
    forkedFrom = json['forked_from'];
    pathAlias = json['path_alias'];
    project = json['project'];
    if (json['custom_domains'] != null) {
      customDomains = <CustomDomains>[];
      json['custom_domains'].forEach((v) {
        customDomains!.add(new CustomDomains.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['space'] = this.space;
    data['group'] = this.group;
    data['name'] = this.name;
    data['role'] = this.role;
    data['code'] = this.code;
    data['path'] = this.path;
    data['envs'] = this.envs;
    data['deps'] = this.deps;
    data['runtime'] = this.runtime;
    data['lib'] = this.lib;
    data['account'] = this.account;
    data['region'] = this.region;
    data['memory'] = this.memory;
    data['timeout'] = this.timeout;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['http_auth'] = this.httpAuth;
    data['log_level'] = this.logLevel;
    data['api_key'] = this.apiKey;
    data['forked_from'] = this.forkedFrom;
    data['path_alias'] = this.pathAlias;
    data['project'] = this.project;
    if (this.customDomains != null) {
      data['custom_domains'] =
          this.customDomains!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomDomains {
  String? domainName;
  String? ipAddress;
  bool? active;

  CustomDomains({this.domainName, this.ipAddress, this.active});

  CustomDomains.fromJson(Map<String, dynamic> json) {
    domainName = json['domain_name'];
    ipAddress = json['ip_address'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain_name'] = this.domainName;
    data['ip_address'] = this.ipAddress;
    data['active'] = this.active;
    return data;
  }
}