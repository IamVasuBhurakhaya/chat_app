import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService {
  APIService._();
  static APIService apiService = APIService._();
  String profileImageURL = '';

  Future<String> profileImageUpload({required File image}) async {
    Uri url = Uri.parse("https://api.imgur.com/3/image");

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Client-ID 85eece0b53c11c4'
      ..files.add(await http.MultipartFile.fromPath('image', image.path));

    var res = await request.send();

    if (res.statusCode == 200) {
      var responseData = await res.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(responseData);
      log('$data');

      profileImageURL = data['data']['link'];
      return profileImageURL;
    } else {
      log('Failed : ${res.statusCode}');
      return '';
    }
  }
}
