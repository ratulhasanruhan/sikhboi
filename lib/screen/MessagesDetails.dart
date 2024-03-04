import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MessagesDetails extends StatefulWidget {
  QueryDocumentSnapshot<Map<String,dynamic>> data;
  dynamic user;
  MessagesDetails({required this.data, required this.user, Key? key}) : super(key: key);

  @override
  State<MessagesDetails> createState() => _MessagesDetailsState();
}

class _MessagesDetailsState extends State<MessagesDetails> {

  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(widget.user['image']),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.user['name'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat').doc(widget.data.id).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return DashChat(
              currentUser: ChatUser(
                id: user,
                firstName: 'Me',
                lastName: '',
              ),
              onSend: (ChatMessage m) {
                setState(() {
                  FirebaseFirestore.instance.collection('chat').doc(widget.data.id).update({
                    'sms': FieldValue.arrayUnion([
                      {
                        'text': m.text,
                        'user': user,
                        'time': DateTime.now(),
                      }
                    ]),
                    'time': Timestamp.now(),
                  });
                });
              },
              messages: [
                for(var i in snapshot.data['sms'])
                  ChatMessage(
                    text: i['text'],
                    user: ChatUser(
                      id: i['user'],
                      firstName: i['user'] == user ? 'Me' : widget.user['name'],
                      lastName: '',
                    ),
                    createdAt: DateTime.fromMillisecondsSinceEpoch(i['time'].millisecondsSinceEpoch),
                  ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }
}
