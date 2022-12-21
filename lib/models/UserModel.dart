class UserModel{
  late int spaceId;
  late String name;
  late String role;
  late String accessToken;

  UserModel(
      {required this.spaceId,
      required this.name,
      required this.role,
      required this.accessToken});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        spaceId: json['spaceId'],//int.parse(json['spaceId'].toString()),
        name: json['name'],
        role: json['role'],
        accessToken: json['accessToken']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spaceId'] = this.spaceId;
    data['name'] = this.name;
    data['role'] = this.role;
    data['accessToken'] = this.accessToken;
    return data;
  }
}

UserModel emptyUserModel(){
  return UserModel(spaceId: 0, name: "name", role: "role", accessToken: "accessToken");
}