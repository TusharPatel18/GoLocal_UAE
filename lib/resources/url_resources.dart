class UrlResources{
  //192.168.29.104/golocal
  static const String mainUrl1 = "http://golocaluae.com/api/";
  static const String mainUrl = "http://golocaluae.com/testing/golocal/api/";

  static const String register = mainUrl + "usersingup";
  static const String login = mainUrl + "userlogin";
  static const String get_emirates = mainUrl + "getallemirates";
  static String getAreas(id) => mainUrl + "getallareas/$id";
  static const String banners = mainUrl + "banners";
  static const String forgot_password = mainUrl + "forgotPassword";
  static const String getPackages = mainUrl + "getpackages";
  static const String reset_password = mainUrl + "resetPassword";
  static const String categories = mainUrl + "categories";
  static const String all_categories = mainUrl + "all_categories";
  static const String get_ads = mainUrl + "getallads";
  static const String create_ad = mainUrl + "postad";
  static const String get_ads_by_category = mainUrl + "getadsbycategoryid";
  static const String delete_ad = mainUrl + "deleteads";
  static const String delete_ads_images = mainUrl + "deleteadimages";
  
  static const String update_ad = mainUrl + "updateads";
  static const String update_ad_Image = mainUrl + "uploadimage";
  static const String add_to_favourite = mainUrl + "addfavoritead";
  static const String get_ad = mainUrl + "getadbyid";
  static const String review = mainUrl + "postadreview";
  static const String favourite_list = mainUrl + "getfavoritelist";
  static const String reviews = mainUrl + "getadreview";
  static const String update_user = mainUrl + "updateuserdetails";
  static const String get_user = mainUrl + "getuserdetails";
  static const String adduserimage = mainUrl + "adduserimage";
  
  static const String deactivateaccount = mainUrl + "deactiveaccount";
  static const String search_ads = mainUrl + "searchads";
  static const String otp_verification = mainUrl + "otpvarification";

}