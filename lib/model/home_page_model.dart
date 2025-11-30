// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromJson(jsonString);

import 'dart:convert';

HomePageModel homePageModelFromJson(String str) =>
    HomePageModel.fromJson(json.decode(str));

String homePageModelToJson(HomePageModel data) => json.encode(data.toJson());

class HomePageModel {
  Data data;
  String status;
  String message;
  int statusCode;

  HomePageModel({
    required this.data,
    required this.status,
    required this.message,
    required this.statusCode,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) => HomePageModel(
    data: Data.fromJson(json["data"]),
    status: json["status"],
    message: json["message"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status": status,
    "message": message,
    "statusCode": statusCode,
  };
}

class Data {
  List<ListDatum> listData;

  Data({required this.listData});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    listData: List<ListDatum>.from(
      json["listData"].map((x) => ListDatum.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "listData": List<dynamic>.from(listData.map((x) => x.toJson())),
  };
}

class ListDatum {
  String imageUrl;
  String title;
  String subTitle;

  ListDatum({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
  });

  factory ListDatum.fromJson(Map<String, dynamic> json) => ListDatum(
    imageUrl: json["imageUrl"],
    title: json["title"],
    subTitle: json["subTitle"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
    "title": title,
    "subTitle": subTitle,
  };
}
