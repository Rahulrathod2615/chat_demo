import 'package:chat_demo/screen/chat/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import '../../model/chat_model.dart';
import '../../model/user_model.dart';
import '../../provider/chat_provider.dart';
import '../../service/chatroom_service.dart';

class ChatPage extends StatelessWidget {
  final String chatRoomId;
  final UserModel friendModel;

  ChatPage({Key? key, required this.chatRoomId, required this.friendModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        if (focusScopeNode.hasPrimaryFocus) {
          focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: ChatAppBar(
                  frdModel: friendModel,)),
          body: Consumer<ChatProvider>(builder: (context, chatProvider, child) {
            return LazyLoadScrollView(
              onEndOfPage: () => chatProvider.loadMore(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                      child: StreamBuilder(
                        stream: ChatRoomService().getConversationMessages(
                            chatRoomId, chatProvider.chatCount),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.length == 0) {
                            return const Center(
                              child: Text("startMessaging"),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text(
                                "something went wrong",
                              ),
                            );
                          }

                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          messageList = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: messageList.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              ChatModel chatModel =
                              ChatModel.fromJson(messageList[index].data());
                              return chatProvider.getMessage(chatModel, messageList,
                                  index, context, chatRoomId, friendModel);
                            },
                          );
                        },
                      )),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    child: MessageTextField(
                      chatProvider,
                      onMessageSend: (message) => chatProvider.sendMessage(
                        sendMsg: message,
                        receiverUid: friendModel.uid,
                        chatRoomId: chatRoomId
                      ),
                    ),
                  ),
                ],
              ),
            );
          },)
      ),
    );
  }
}
