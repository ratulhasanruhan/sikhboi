import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/time_difference.dart';
import 'package:skeletons/skeletons.dart';
import 'MessagesDetails.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {

  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color2dark,
        centerTitle: true,
      ),
      body: FirestoreListView(
        query: FirebaseFirestore.instance.collection('chat').where('user', arrayContains: user).orderBy('time', descending: true),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        primary: true,
        shrinkWrap: true,
        itemBuilder: (context, snapshot) {
          return Column(
            children: [
              Card(
                color: Colors.white,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(snapshot['user'][1]).snapshots(),
                  builder: (context,AsyncSnapshot usr) {
                    if(usr.hasData){
                      return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesDetails(data: snapshot, user: usr.data,)));
                        },
                        onLongPress: () async{
                          showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(100, 100, 0, 100),
                              items: [
                                PopupMenuItem(
                                  child: Text('Block'),
                                  value: 'block',
                                  onTap: () async{
                                    await FirebaseFirestore.instance.collection('chat').doc(snapshot.id).delete();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(usr.data['image']),
                          ),
                          minLeadingWidth: 0,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  usr.data['name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                calculateTimeDifference(startDate: snapshot['time'].toDate(), endDate: DateTime.now()).replaceAll('0 সেকেন্ড', 'এখন').replaceAll('-', ''),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          subtitle: Text(
                            snapshot['sms'].last['text'] ?? '',
                            maxLines: 1,
                          ),
                        ),
                      );
                    }
                    return SkeletonLine();
                  }
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
