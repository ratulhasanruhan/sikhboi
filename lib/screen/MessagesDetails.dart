import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/utils/colors.dart';

import 'SendOffer.dart';

class MessagesDetails extends StatefulWidget {
  QueryDocumentSnapshot<Map<String,dynamic>> data;
  dynamic user;
  MessagesDetails({required this.data, required this.user, super.key});

  @override
  State<MessagesDetails> createState() => _MessagesDetailsState();
}

class _MessagesDetailsState extends State<MessagesDetails> {

  var user = Hive.box('user').get('phone');
  var box = Hive.box('user');
  var type = Hive.box('user').get('type');

  final database = FirebaseFirestore.instance.collection('offer_requests');

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
        actions: [
          box.get('type') != null
          ? IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SendOffer(user: widget.user,)));
            },
            icon: Badge(
              child: Icon(Icons.paid),
              backgroundColor: primaryColor,
              label: FutureBuilder(
                  future: type == 'seller'
                      ? database.where('sender', isEqualTo: user).where('receiver', isEqualTo: widget.user['phone']).get()
                      : database.where('receiver', isEqualTo: user).where('sender', isEqualTo: widget.user['phone']).get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if(snapshot.hasData){
                      return Text(
                        snapshot.data.docs.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  }
              )
            ),
          )
          : SizedBox(),
        ],
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
