class BannerModel {
  String bannerUrl;
  String bannerName;
  String bannerText;

  BannerModel({this.bannerUrl, this.bannerName, this.bannerText});

  BannerModel.fromJson(Map<String, dynamic> json) {
    bannerUrl = json['bannerUrl'];
    bannerName = json['bannerName'];
    bannerText = json['bannerText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerUrl'] = this.bannerUrl;
    data['bannerName'] = this.bannerName;
    data['bannerText'] = this.bannerText;
    return data;
  }
}
