class AccessTokenModel {
  String? id;
  String? key;

  AccessTokenModel({this.id, this.key});

  AccessTokenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    return data;
  }
}