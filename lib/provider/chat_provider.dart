import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../model/chat_model.dart';
import '../model/user_model.dart';
import '../screen/chat/views/chat_view.dart';
import '../service/chatroom_service.dart';
import '../widget/app_date_clip.dart';

class ChatProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  ChatRoomService chatRoomService = ChatRoomService();
  int chatCount = 15;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Future<void> sendMessage({
    String? sendMsg,
    String? imageUrl,
    String? receiverUid,
    String? chatRoomId,
  }) async {
    ChatModel chatModel = ChatModel(
      message: sendMsg ?? "",
      imageUrl: imageUrl ?? "",
      time: DateTime.now().toString(),
      messageType: (sendMsg == null || sendMsg.isEmpty) ? 2 : 1,
      receiverId: receiverUid,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    chatRoomService.sendConversationMessage(chatRoomId!, chatModel);
    notifyListeners();
  }

  Widget getMessage(
      ChatModel chatModel,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messageList,
      int index,
      BuildContext context,
      String chatRoomId,
      UserModel friendModel) {
    bool isSameDate = true;
    final String dateString = "${chatModel.time}";
    final DateTime date = DateTime.parse(dateString);

    if (index == messageList.length - 1) {
      isSameDate = false;
    } else {
      ChatModel chatModel =
      ChatModel.fromJson(messageList.toList()[index + 1].data());

      final String prevDateString = "${chatModel.time}";

      final DateTime prevDate = DateTime.parse(prevDateString);
      isSameDate = date.isSameDate(prevDate);
    }
    bool? isNew = chatModel.isRead;
    bool? toMe = chatModel.receiverId == FirebaseAuth.instance.currentUser!.uid;

    if (index == messageList.length - 1 || !(isSameDate)) {
      //
      if (!isNew! && toMe) {
        return FutureBuilder(
          future:
          chatRoomService.checkMsgSeen(chatRoomId, "${friendModel.uid}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StickyHeader(
                header: Center(
                  child: AppDateChip(
                      date: date.dateCalculation(
                          DateTime.parse("${chatModel.time}"))),
                ),
                content: MessageBubble(
                  message: chatModel.message,
                  imageUrl: chatModel.imageUrl,
                  messageType: chatModel.messageType,
                  sendMsgTime: DateTime.parse("${chatModel.time}"),
                  isSender: (FirebaseAuth.instance.currentUser!.uid ==
                      chatModel.senderId)
                      ? true
                      : false,
                ),
              );
            }
            return StickyHeader(
              header: Center(
                child: AppDateChip(
                    date: date
                        .dateCalculation(DateTime.parse("${chatModel.time}"))),
              ),
              content: MessageBubble(
                message: chatModel.message,
                imageUrl: chatModel.imageUrl,
                messageType: chatModel.messageType,
                sendMsgTime: DateTime.parse("${chatModel.time}"),
                isSender: (FirebaseAuth.instance.currentUser!.uid ==
                    chatModel.senderId)
                    ? true
                    : false,
              ),
            );
          },
        );
      }
      return StickyHeader(
        header: Center(
          child: AppDateChip(
              date: date.dateCalculation(DateTime.parse("${chatModel.time}"))),
        ),
        content: MessageBubble(
          isSeen: (chatModel.isRead == true) ? true : false,
          isSent: (chatModel.isRead == false) ? true : false,
          message: chatModel.message,
          imageUrl: chatModel.imageUrl,
          messageType: chatModel.messageType,
          sendMsgTime: DateTime.parse("${chatModel.time}"),
          isSender:
          (FirebaseAuth.instance.currentUser!.uid == chatModel.senderId)
              ? true
              : false,
        ),
      );
    }
    //
    else {
      if (!isNew! && toMe) {
        return FutureBuilder(
          future:
          chatRoomService.checkMsgSeen(chatRoomId, "${friendModel.uid}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MessageBubble(
                messageType: chatModel.messageType,
                message: chatModel.message,
                imageUrl: chatModel.imageUrl,
                sendMsgTime: DateTime.parse("${chatModel.time}"),
                isSender: (FirebaseAuth.instance.currentUser!.uid ==
                    chatModel.senderId)
                    ? true
                    : false,
              );
            }
            return MessageBubble(
              messageType: chatModel.messageType,
              message: chatModel.message,
              imageUrl: chatModel.imageUrl,
              sendMsgTime: DateTime.parse("${chatModel.time}"),
              isSender:
              (FirebaseAuth.instance.currentUser!.uid == chatModel.senderId)
                  ? true
                  : false,
            );
          },
        );
      }
      return MessageBubble(
        isSeen: (chatModel.isRead == true) ? true : false,
        isSent: (chatModel.isRead == false) ? true : false,
        messageType: chatModel.messageType,
        message: chatModel.message,
        imageUrl: chatModel.imageUrl,
        sendMsgTime: DateTime.parse("${chatModel.time}"),
        isSender: (FirebaseAuth.instance.currentUser!.uid == chatModel.senderId)
            ? true
            : false,
      );
    }
  }

  void loadMore() {
    chatCount = chatCount + 15;
    notifyListeners();
  }
}

const String dateFormatter = 'MMMM dd, y';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  DateTime dateCalculation(DateTime sendMsgDate) {
    final datetime = DateTime.now();
    var diff =
        DateTime(datetime.year, datetime.month, datetime.day, datetime.hour)
            .difference(
            DateTime(sendMsgDate.year, sendMsgDate.month, sendMsgDate.day))
            .inDays;
    //log("diff--->$diff");
    if (diff == 0) {
      return sendMsgDate;
    } else if (diff == -1) {
      return DateTime(sendMsgDate.year, sendMsgDate.month, sendMsgDate.day - 1);
    } else {
      return DateTime(sendMsgDate.year, sendMsgDate.month, sendMsgDate.day);
    }
  }
}