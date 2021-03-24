class PackageModel {
  String id;
  String title;
  String description;
  String amount;
  PackageModel({this.id, this.title, this.description, this.amount});

  PackageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    return data;
  }
}
