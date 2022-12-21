import 'package:hive/hive.dart';

class ProjectModel{
  String id;
  String name;
  String description;
  String created;
  String region;

  ProjectModel(this.id, this.name, this.description, this.created,
      this.region);

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
      json['id'],
      json['name'],
      json['description'],
      json['created'],
      json['region']
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created'] = this.created;
    data['region'] = this.region;
    return data;
  }
}