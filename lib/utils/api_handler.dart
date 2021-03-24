import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'api_response.dart';
import 'package:http/http.dart' as http;
import 'error_handler.dart';

class ApiHandler {
  final http.Client _client;

  ApiHandler(this._client);

  Future<ApiResponse> post(url, {Map<String, String> body}) async {
    try {
      http.Response response = await _client.post(url, body: body);
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        throw ErrorHandler(code: response.statusCode);
      }
    } on FormatException {
      throw ErrorHandler(message: "Bad Response Format");
    } on SocketException {
      throw ErrorHandler(message: "Internet Connectino Failure");
    } on HttpException {
      throw ErrorHandler(message: "Connection Problem");
    } on Exception catch (ex) {
      throw ErrorHandler(message: ex.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ApiResponse> postImage(url,
      {Map<String, String> body, List<File> images: const [], List<String> title: const [],}) async {
    try {
      http.MultipartRequest request = http.MultipartRequest('post', Uri.parse(url));
      body.entries.forEach((element) {
        request..fields[element.key] = element.value;
      });
      // List<http.MultipartFile> filesToUp = [];
      if (images.length > 0) {
        int i = 1;
        for (var element in images) {
          request.files
            ..add((await http.MultipartFile.fromPath("file$i", element.path)));
          print(element.path);
          i = i + 1;
        }
      }
      if (title.length > 0) {
        int j = 1;
        for (var element1 in title) {
          request..fields["title$j"] = element1;
          j = j + 1;
        }
      }
      // request.files.addAll(filesToUp);
      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return ApiResponse(
            status: 'success', message: "Ad Created Successfully", data: {});
      } else {
        throw ErrorHandler(code: response.statusCode);
      }
    } on FormatException {
      throw ErrorHandler(message: "Bad Response Format");
    } on SocketException {
      throw ErrorHandler(message: "Internet Connectino Failure");
    } on HttpException {
      throw ErrorHandler(message: "Connection Problem");
    } on Exception catch (ex) {
      throw ErrorHandler(message: ex.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ApiResponse> postImage1(url,
      {Map<String, String> body, File licence,}) async {
    try {
      print(licence.path);
      http.MultipartRequest request = http.MultipartRequest('post', Uri.parse(url));
      body.entries.forEach((element) async {
          request..fields[element.key] = element.value;
      });
      if (licence != null) {
                print("abc");
          request.files
            ..add((await http.MultipartFile.fromPath("licence", licence.path)));
      }
      http.StreamedResponse response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return ApiResponse(
            status: 'success', message: "User Updated Successfully", data: {});
      } else {
        throw ErrorHandler(code: response.statusCode);
      }
    } on FormatException {
      throw ErrorHandler(message: "Bad Response Format");
    } on SocketException {
      throw ErrorHandler(message: "Internet Connectino Failure");
    } on HttpException {
      throw ErrorHandler(message: "Connection Problem");
    } on Exception catch (ex) {
      throw ErrorHandler(message: ex.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ApiListResponse> postList(url, {Map<String, String> body}) async {
    try {
      http.Response response = await _client.post(url, body: body);
      if (response.statusCode == 200) {
        return ApiListResponse.fromJson(json.decode(response.body));
      } else {
        throw ErrorHandler(code: response.statusCode);
      }
    } on FormatException {
      throw ErrorHandler(message: "Bad Response Format");
    } on SocketException {
      throw ErrorHandler(message: "Internet Connectino Failure");
    } on HttpException {
      throw ErrorHandler(message: "Connection Problem");
    } on Exception catch (ex) {
      throw ErrorHandler(message: ex.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ApiListResponse> getList(url) async {
    try {
      http.Response response = await _client.get(url);
      if (response.statusCode == 200) {
        return ApiListResponse.fromJson(json.decode(response.body));
      } else {
        throw ErrorHandler(code: response.statusCode);
      }
    } on FormatException {
      throw ErrorHandler(message: "Bad Response Format");
    } on SocketException {
      throw ErrorHandler(message: "Internet Connectino Failure");
    } on HttpException {
      throw ErrorHandler(message: "Connection Problem");
    } on Exception catch (ex) {
      throw ErrorHandler(message: ex.toString().replaceAll("Exception: ", ""));
    }
  }
}
