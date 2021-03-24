class AdModel {
  String id;
  String title;
  String description;
  String adstype;
  String categoriesId;
  List<String> imageurl;
  List<String> imagetitle;
  List<String> imageid;
  bool userfavorite;
  String createdAt;
  String userid;
  List<String> categories;
  AdModel(
      {this.id,
      this.title,
      this.description,
      this.adstype,
      this.categoriesId,
      this.imageurl,
      this.imagetitle,
      this.imageid,
      this.userfavorite,
      this.createdAt,
      this.userid});

  AdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    adstype = json['adstype'];
    categoriesId = json['categoriesId'];

    List<String> data = [];
    if (json['imageurl'] != null) {
      List d = json['imageurl'];
      d.forEach((element) {
        data.add(element);
      });
    }
    imageurl = data;

    List<String> data1 = [];
    if (json['imagetitle'] != null) {
      List d1 = json['imagetitle'];
      d1.forEach((element) {
        data1.add(element);
      });
    }
    imagetitle = data1;

    List<String> data2 = [];
    if (json['imageid'] != null) {
      List d2 = json['imageid'];
      d2.forEach((element) {
        data2.add(element);
      });
    }
    imageid = data2;

    List<String> cats = [];
    if (json['category'] != null) {
      List d = json['category'];
      d.forEach((element) {
        cats.add(element);
      });
    }
    categories = cats;

    userfavorite = json['userfavorite'];
    createdAt = json['createdate'];
    userid = json['userid'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['adstype'] = this.adstype;
    data['categoriesId'] = this.categoriesId;
    data['imageurl'] = this.imageurl;
    data['imagetitle'] = this.imagetitle;
    data['category'] = this.categories;
    data['userfavorite'] = this.userfavorite;
    data['createdate'] = this.createdAt;
    data['userid'] = this.userid;
    return data;
  }
}
