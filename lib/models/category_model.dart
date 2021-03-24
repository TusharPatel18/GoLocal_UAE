class CategoryModel {
  String id;
  String categoriesname;
  String categoriestext;
  String categoriesurl;
  String subcategories;
  bool userfavorite;

  CategoryModel(
      {this.id,
      this.categoriesname,
      this.categoriestext,
      this.categoriesurl,
      this.subcategories,
      this.userfavorite});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoriesname = json['categoriesname'];
    categoriestext = json['categoriestext'];
    categoriesurl = json['categoriesurl'];
    subcategories = json['subcategories'];
    userfavorite = json['userfavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoriesname'] = this.categoriesname;
    data['categoriestext'] = this.categoriestext;
    data['categoriesurl'] = this.categoriesurl;
    data['subcategories'] = this.subcategories;
    data['userfavorite'] = this.userfavorite;
    return data;
  }
}
