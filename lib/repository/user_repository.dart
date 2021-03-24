import 'dart:convert';
import 'dart:io';

import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/url_resources.dart';
import '../utils/api_response.dart';
import '../utils/api_handler.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final ApiHandler _handler;

  UserRepository(this._handler);

  Future verifyOtp(
    otp,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiResponse response =
        await _handler.post(UrlResources.otp_verification, body: {
      "emailId": user.emailId,
      "otp": otp,
    });

    if (response.status == 'success') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("IS_LOGGED_IN", true);
      return response.message;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<String> register({
    firstName,
    lastName,
    mobileNumber,
    email,
    password,
    deviceToken,
    usertype,
  }) async {
    ApiResponse response = await _handler.post(UrlResources.register, body: {
      "firstName": firstName,
      "lastName": lastName,
      "emailId": email,
      "password": password,
      "deviceToken": deviceToken,
      "userType": usertype,
      "deviceType": "Android",
      "mobileNo": mobileNumber
    });
    if (response.status == 'success') {
      print(response.data);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("USER", json.encode(response.data));
      preferences.setString("OTP", response.data['otp'].toString());
      return response.message;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<String> login({
    email,
    password,
    deviceToken,
  }) async {
    ApiResponse response = await _handler.post(UrlResources.login, body: {
      "emailId": email,
      "password": password,
      "deviceToken": deviceToken,
      "deviceType": "Android",
    });

    if (response.status == 'success') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("IS_LOGGED_IN", true);
      preferences.setString("USER", json.encode(response.data));
      //Fluttertoast.showToast(msg: "Success");
      getUserNew();
      return response.message;
    } else {
      //Fluttertoast.showToast(msg: "Error");
      throw ErrorHandler(message: response.message);
    }
  }

  Future<User> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    return user;
  }

  Future deactivateUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiResponse response = await _handler.post(UrlResources.deactivateaccount,
        body: {
      "user_id": user.id.toString(),
    });

    if (response.status == 'success') {
      preferences.clear();
      return true;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<User> getUserNew() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiResponse response = await _handler.post(UrlResources.get_user, body: {
      "user_id": user.id.toString(),
    });

    if (response.status == 'success') {
      preferences.setString("USER", json.encode(response.data));
      print(response.data.toString());
      return User.fromJson(response.data);
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future updateUser1(
      {
      String firstName,
      lastName,
      password,
      facebook,
      instagram,
      twitter,
      address,
      File images,
      }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.postImage1(UrlResources.update_user, body: {
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
      "facebook": facebook.toString() ?? "",
      "instagram": instagram.toString() ?? "",
      "twitter": twitter.toString() ?? "",
      "userId": user.id.toString(),
      "address": address.toString() ?? "",
      "licence": images.toString()
    },
      licence : images,
    );
    print(response.status.toString());
    if (response.status == 'success') {
      return response.message;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<String> updateUser(
      {String firstName,
        lastName,
        password,
        facebook,
        instagram,
        twitter,
        address,
      }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.post(UrlResources.update_user, body: {
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
      "facebook": facebook.toString() ?? "",
      "instagram": instagram.toString() ?? "",
      "twitter": twitter.toString() ?? "",
      "userId": user.id.toString(),
      "address": address ?? "",
    });
    if (response.status == 'success') {
      return response.message;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<bool> changeImage({
    File image,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(UrlResources.adduserimage))..fields['user_id'] = user.id.toString()..files.add((await http.MultipartFile.fromPath('file', image.path)));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ErrorHandler(message: "Couldn't Update image");
    }
  }

  Future<bool> resetPassword({
    String email,
  }) async {
    ApiResponse response = await _handler
        .post(UrlResources.forgot_password, body: {"emailId": email});

    if (response.status == 'success') {
      return true;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }
}
