import 'package:deta/models/MicroModel.dart';

class DomainGroupModel {
  int? group;
  CustomDomains? customDomains;

  DomainGroupModel({required this.group,required this.customDomains});

  DomainGroupModel.fromJson(Map<String, dynamic> json) {
    group = json['group'];
    customDomains = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group'] = this.group;
    data['value'] = this.customDomains;
    return data;
  }
}
