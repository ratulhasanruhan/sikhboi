import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:sikhboi/utils/colors.dart';
import '../model/LearnChatModel.dart';

class LearnChat extends StatefulWidget {
  const LearnChat({super.key});

  @override
  State<LearnChat> createState() => _LearnChatState();
}

class _LearnChatState extends State<LearnChat> {
  final ScrollController scrollController = ScrollController();
  TextEditingController writeController = TextEditingController();
  List<LearnChatModel> messageList = [
    LearnChatModel(
      chat: "স্পোকেন ইংলিশ প্রাকটিস করার জন্য এখানে সঠিক গ্রামার টাইপ করুন!",
      isUser: false,
    ),
  ];

  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          color: backGreen,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: TextField(
            controller: writeController,
            decoration: InputDecoration(
              hintText: "Ask a question...",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              suffixIcon: IconButton(
                onPressed: () async{
                  setState(() {
                    isLoaded = true;
                  });
                  messageList.add(
                    LearnChatModel(
                      chat: writeController.text.trim(),
                      isUser: true,
                    ),
                  );

                  await FirebaseFirestore.instance.collection('english').get().then((value) {
                    if(value.docs.where((element) => element['q'] == writeController.text.trim()).toList().isNotEmpty){
                      value.docs.where((element) => element['q'] == writeController.text.trim()).forEach((element) {
                        messageList.add(
                          LearnChatModel(
                            chat: element['a'],
                            isUser: false,
                          ),
                        );
                      });

                    }
                    else{
                      messageList.add(
                        LearnChatModel(
                          chat: "Sorry, Your grammar is not correct. Please try again.",
                          isUser: false,
                        ),
                      );
                    }
                  });
                  setState(() {
                    isLoaded = false;
                  });
                  writeController.clear();
                  scrollController.animateTo(
                    scrollController.position.maxScrollExtent + 100,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );

                },
                icon: isLoaded ? CircularProgressIndicator(
                  backgroundColor: Colors.red.withOpacity(0.6),
                ) :
                Icon(
                  Icons.send,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: messageList.isEmpty
      ? Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                "Start Chatting",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      )
      : ListView.builder(
        shrinkWrap: true,
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        itemCount: messageList.length,
        itemBuilder: (context, index) {
          return ChatBubble(
            clipper: messageList[index].isUser ? ChatBubbleClipper5(type: BubbleType.sendBubble) : ChatBubbleClipper5(type: BubbleType.receiverBubble),
            alignment: messageList[index].isUser ? Alignment.topRight : Alignment.topLeft,
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            backGroundColor: messageList[index].isUser ? primaryColor : greenish,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Text(
                messageList[index].chat,
                style: TextStyle(
                  color: messageList[index].isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
