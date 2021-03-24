class ReviewModel {
  String adId;
  String userId;
  String emailId;
  String fullname;
  String rating;
  String review;
  String title;
  String description;
  String categoriesId;

  ReviewModel(
      {this.adId,
      this.userId,
      this.emailId,
      this.fullname,
      this.rating,
      this.review,
      this.title,
      this.description,
      this.categoriesId});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    adId = json['adId'];
    userId = json['userId'];
    emailId = json['emailId'];
    fullname = json['fullname'];
    rating = json['rating'];
    review = json['review'];
    title = json['title'];
    description = json['description'];
    categoriesId = json['categoriesId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adId'] = this.adId;
    data['userId'] = this.userId;
    data['emailId'] = this.emailId;
    data['fullname'] = this.fullname;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['title'] = this.title;
    data['description'] = this.description;
    data['categoriesId'] = this.categoriesId;
    return data;
  }
}
