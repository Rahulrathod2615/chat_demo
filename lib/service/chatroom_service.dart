import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../model/chat_model.dart';
import '../model/user_model.dart';

class ChatRoomService {
  final CollectionReference chatroomCollection =
      FirebaseFirestore.instance.collection('ChatRoom');
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsers() {
    return db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }

  Future<void> sendConversationMessage(
      String chatRoomId, ChatModel chatModel) async {
    try {
      await chatroomCollection
          .doc('$chatRoomId')
          .collection('Chats')
          .add(chatModel.toJson());
    } on FirebaseException catch (e) {
      log("Catch exception in sendMessage--->${e.message}");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getConversationMessages(
      String chatRoomId, int chatCount) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = chatroomCollection
          .doc(chatRoomId)
          .collection('Chats')
          .orderBy('time', descending: true)
          .limit(chatCount)
          .snapshots();
      return snapshot;
    } on FirebaseException catch (e) {
      log("Catch exception in Get Conversation Messages---->${e.message}");
      return null;
    }
  }

  Future<void> checkMsgSeen(String chatRoomId, String senderId) async {
    QuerySnapshot<Map<String, dynamic>> query = await chatroomCollection
        .doc(chatRoomId)
        .collection('Chats')
        .where('senderId', isEqualTo: senderId)
        .where('isRead', isEqualTo: false)
        .get();

    query.docs.forEach((element) {
      element.reference.update({'isRead': true});
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? messageCount(String chatRoomId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = FirebaseFirestore
          .instance
          .collection('ChatRoom')
          .doc(chatRoomId)
          .collection('Chats')
          .where('isRead', isEqualTo: false)
          .where('receiverId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
      return snapshot;
    } on FirebaseException catch (err) {
      log("Catch exception in messageCount--->$err");
    }

    return null;
  }
}
