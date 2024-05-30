import 'package:chat_demo/service/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/user_model.dart';
import '../../service/chatroom_service.dart';
import 'chat_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar:AppBar(title: const Text('Chats'),actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut(context);
            },
          ),
        ],),
        body: StreamBuilder<List<UserModel>>(
          stream: ChatRoomService().getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if (user.uid == AuthService().currentUser()!.uid) {
                  return Container();
                }
                String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                String chatRoomId = user.uid.hashCode <= currentUserId.hashCode
                    ? "${user.uid}-$currentUserId"
                    : "$currentUserId-${user.uid}";
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: ChatRoomService().messageCount(chatRoomId),
                  builder: (context, snapshot) {
                    return ListTile(
                      title: Text(user.email),
                      trailing:Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:snapshot.data?.docs.length == 0 ? Colors.white : Colors.blue,
                        ),
                        child:snapshot.data?.docs.length == 0 ? null : Text(
                          "${snapshot.data?.docs.length}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        String currentUserId = FirebaseAuth.instance.currentUser!.uid;
                        String chatRoomId = user.uid.hashCode <= currentUserId.hashCode
                            ? "${user.uid}-$currentUserId"
                            : "$currentUserId-${user.uid}";
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ChatPage(
                            chatRoomId: chatRoomId,
                            friendModel: user,
                          );
                        },));
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
