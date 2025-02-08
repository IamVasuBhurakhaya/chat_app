import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService._();

  static APIService apiService = APIService._();

  Future<String> uploadUserImage({required File image}) async {
    Uri url = Uri.parse("https://api.imgur.com/3/image");

    Uint8List imageList = await image.readAsBytes();

    String userImage = base64Encode(imageList);

    String userURL =
        "https://static.vecteezy.com/system/resources/thumbnails/019/900/306/small_2x/happy-young-cute-illustration-face-profile-png.png";

    http.Response res = await http.post(
      url,
      headers: {
        'Authorization': "Client-ID 85eece0b53c11c4",
      },
      body: userImage,
    );

    log("Status Code : ${res.statusCode}");
    if (res.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(res.body);

      log("Response Data : ${data['data']['link']}");
      userURL = data['data']['link'];
    }

    return userURL;
  }
}
