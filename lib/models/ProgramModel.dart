class ProgramModel {
  String? programId;
  String? name;

  ProgramModel({this.programId, this.name});

  ProgramModel.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    data['name'] = this.name;
    return data;
  }
}