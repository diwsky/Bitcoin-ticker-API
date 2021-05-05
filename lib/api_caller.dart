import 'dart:convert';
import 'package:bitcoin_ticker/constants.dart';
import 'package:http/http.dart' as http;

class ApiCaller {
  var url;

  ApiCaller({this.url});

  Future fetch() async {
    var uri = Uri.parse(url);
    http.Response response =
        await http.get(uri, headers: {HEADER_KEY: API_KEY});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch URL: ${response.body}');
    }
  }
}
