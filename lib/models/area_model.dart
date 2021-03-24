class AreaModel {
  String id;
  String name;
  String emirateId;

  AreaModel({this.id, this.name, this.emirateId});

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    emirateId = json['emirate_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emirate_id'] = this.emirateId;
    return data;
  }
}
