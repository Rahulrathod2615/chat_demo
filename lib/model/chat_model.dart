import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    this.message,
    this.time,
    this.messageType,
    this.senderId,
    this.receiverId,
    this.imageUrl,
    this.isRead = false,
  });

  String? message;
  String? imageUrl;
  String? time;
  num? messageType;
  String? senderId;
  String? receiverId;
  bool? isRead;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      message: json["message"],
      time: json["time"],
      messageType: json["messageType"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      isRead: json["isRead"],
      imageUrl: json["imageUrl"]);

  Map<String, dynamic> toJson() => {
        "message": message,
        "time": time,
        "messageType": messageType,
        "senderId": senderId,
        "receiverId": receiverId,
        "imageUrl": imageUrl,
        "isRead": isRead,
      };
}
