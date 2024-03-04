// To parse this JSON data, do
//
//     final learnChatModel = learnChatModelFromJson(jsonString);

import 'dart:convert';

LearnChatModel learnChatModelFromJson(String str) => LearnChatModel.fromJson(json.decode(str));

String learnChatModelToJson(LearnChatModel data) => json.encode(data.toJson());

class LearnChatModel {
  String chat;
  bool isUser;

  LearnChatModel({
    required this.chat,
    required this.isUser,
  });

  factory LearnChatModel.fromJson(Map<String, dynamic> json) => LearnChatModel(
    chat: json["chat"],
    isUser: json["isUser"],
  );

  Map<String, dynamic> toJson() => {
    "chat": chat,
    "isUser": isUser,
  };
}
