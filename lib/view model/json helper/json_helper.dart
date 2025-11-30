import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:learning_a_to_z/model/home_page_model.dart';

class JsonHelper {
  static Future<List<HomePageModel>> loadJson() async {
    final String response = await rootBundle.loadString(
      'assets/home_page_json.json',
    );
    final data = jsonDecode(response);
    var list = data["data"]["listData"] as List;
    return list.map((e) => HomePageModel.fromJson(e)).toList();
  }
}
