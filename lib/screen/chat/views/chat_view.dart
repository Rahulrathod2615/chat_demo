import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/user_model.dart';
import '../../../provider/chat_provider.dart';
import '../../../widget/app_chat_textfield.dart';
import '../../../widget/app_message_bubble.dart';
import '../../../widget/common_text.dart';

class ChatAppBar extends StatelessWidget {
  final UserModel frdModel;

  const ChatAppBar({
    super.key,
    required this.frdModel,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 108,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Row(
          children: [
            Icon(
              Icons.navigate_before,
              color: Colors.black,
              size: 35,
            ),
            CommonText(
              text: 'chat',
              fontSize: 20,
              color: Colors.black,
            )
          ],
        ),
      ),
      elevation: 1,
      centerTitle: true,
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isSender;
  final bool isSeen;
  final bool isSent;
  final String? message;
  final String? imageUrl;
  final num? messageType;
  final String? senderProfileImage;
  final String? receiverProfileImage;
  final DateTime? sendMsgTime;
  final void Function()? onLongPress;
  final void Function()? onImageDeleteOnTap;
  final void Function()? imageOnTap;

  const MessageBubble(
      {super.key,
      this.isSender = false,
      this.isSeen = false,
      this.isSent = false,
      this.message,
      this.messageType,
      this.sendMsgTime,
      this.onLongPress,
      this.imageUrl,
      this.onImageDeleteOnTap,
      this.imageOnTap,
      this.senderProfileImage,
      this.receiverProfileImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Row(
        mainAxisAlignment:
            (isSender) ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isSender == false)
            if (messageType == 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (receiverProfileImage != null &&
                                receiverProfileImage!.isNotEmpty)
                            ? Image.network(
                                '$receiverProfileImage',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              )
                            : const Icon(Icons.supervised_user_circle_sharp),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onLongPress: onImageDeleteOnTap,
                          onTap: imageOnTap,
                          child: SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  "$imageUrl",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: CommonText(
                                      text: "Something went wrong",
                                    ));
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress != null) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return child;
                                  },
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: CommonText(
                              fontSize: 12,
                              text:
                                  DateFormat('hh:mm a').format(sendMsgTime ?? DateTime.now()).toLowerCase()),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (receiverProfileImage != null &&
                          receiverProfileImage!.isNotEmpty)
                      ? Image.network(
                          '$receiverProfileImage',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        )
                      : const Icon(Icons.supervised_user_circle_sharp)
                ),
              ),
          if (messageType == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              child: Column(
                crossAxisAlignment: (isSender)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onLongPress: onLongPress,
                    child: AppMessageBubble(
                        seen: isSeen,
                        sent: isSent,
                        text: "$message",
                        isSender: isSender,
                        textStyle: TextStyle(
                            fontSize: 17,
                            color: (isSender)
                                ? Colors.white
                                : Colors.black),
                        color: (isSender)
                            ?  Colors.blue
                            : Colors.grey.shade300,
                        tail: true),
                  ),
                  CommonText(
                    text:
                        DateFormat('hh.mm a').format(sendMsgTime ?? DateTime.now()).toLowerCase(),
                  )
                ],
              ),
            ),
          if (isSender)
            if (messageType == 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onLongPress: onImageDeleteOnTap,
                          onTap: imageOnTap,
                          child: SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  "$imageUrl",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: CommonText(
                                      text: "Something went wrong",
                                    ));
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress != null) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return child;
                                  },
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CommonText(
                            fontSize: 12,
                            text:
                                DateFormat('hh:mm a').format(sendMsgTime ?? DateTime.now()).toLowerCase()),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: (senderProfileImage != null &&
                                senderProfileImage!.isNotEmpty)
                            ? Image.network(
                                '$senderProfileImage',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              )
                            : const Icon(Icons.supervised_user_circle_sharp),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (senderProfileImage != null &&
                          senderProfileImage!.isNotEmpty)
                      ? Image.network(
                          '$senderProfileImage',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                        )
                      : const Icon(Icons.supervised_user_circle_sharp)
                ),
              ),
        ],
      ),
    );
  }
}

class MessageTextField extends StatelessWidget {
  final void Function(String)? onMessageSend;
  final ChatProvider controller;

  const MessageTextField(this.controller, {super.key, this.onMessageSend});

  @override
  Widget build(BuildContext context) {
    return AppMessageBar(
      messageBarColor: Colors.white,
      textFieldColor: Colors.grey.withOpacity(0.3),
      onSend: onMessageSend,
    );
  }
}
