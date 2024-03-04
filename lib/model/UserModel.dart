// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.name,
    required this.phone,
    required this.password,
    required this.point,
    required this.image,
    required this.upgraded,
  });

  String name;
  String phone;
  String password;
  int point;
  String image;
  bool upgraded;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    phone: json["phone"],
    password: json["password"],
    point: json["point"],
    image: json["image"],
    upgraded: json["upgraded"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone": phone,
    "password": password,
    "point": point,
    "image": image,
    "upgraded": upgraded,
  };
}
