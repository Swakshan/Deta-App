class ProjectTokenModel {
  String? projectId;
  String? name;
  String? description;
  String? created;
  bool? active;
  String? accessLevel;
  String? accessToken;

  ProjectTokenModel(
      {this.projectId,
        this.name,
        this.description,
        this.created,
        this.active,
        this.accessLevel,
        this.accessToken});

  ProjectTokenModel.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    name = json['name'];
    description = json['description'];
    created = json['created'];
    active = json['active'];
    accessLevel = json['access_level'];
    accessToken = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created'] = this.created;
    data['active'] = this.active;
    data['access_level'] = this.accessLevel;
    data['value'] = this.accessToken;
    return data;
  }
}
