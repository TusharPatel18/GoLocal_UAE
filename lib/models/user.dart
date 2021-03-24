class User {
  int id;
  String firstName;
  String lastName;
  String emailId;
  String userType;
  String deviceToken;
  String deviceType;
  String mobileNo;
  String facebook;
  String twitter;
  String instagram;
  String imageUrl;
  String address;
  String image;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.emailId,
      this.userType,
      this.deviceToken,
      this.deviceType,
      this.facebook,
      this.instagram,
      this.twitter,
      this.mobileNo,
      this.imageUrl,
      this.address,
      this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    userType = json['userType'];
    deviceToken = json['deviceToken'];
    deviceType = json['deviceType'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    twitter = json['twitter'];
    mobileNo = json['mobileNo'];
    imageUrl = json['imageUrl'];
    address = json['address'];
    image = json['licence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['userType'] = this.userType;
    data['deviceToken'] = this.deviceToken;
    data['deviceType'] = this.deviceType;
    data['mobileNo'] = this.mobileNo;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['twitter'] = this.twitter;
    data['imageUrl'] = this.imageUrl;
    data['address'] = this.address;
    data['licence'] = this.image;
    return data;
  }
}
