import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:skeletons/skeletons.dart';

import '../utils/time_difference.dart';

class CommentScreen extends StatefulWidget {
  String postId;
  String userPhoto;
  String postUser;
  CommentScreen({required this.postId, required this.userPhoto, required this.postUser, Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();


  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(data[i]['user']).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return ListTile(
                    leading: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: new BorderRadius.all(Radius.circular(50))),
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: CommentBox.commentImageParser(
                              imageURLorPath: snapshot.data['image'])),
                    ),
                    title: Text(
                      snapshot.data['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data[i]['message']),
                    trailing: Text(calculateTimeDifference(startDate: data[i]['date'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago', style: TextStyle(fontSize: 10)),
                  );
                }
                return SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 30,
                    borderRadius: BorderRadius.circular(10),
                  )
                );
              }
            ),
          )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            var data = snapshot.data.docs;

            return Container(
              child: CommentBox(
                userImage: CommentBox.commentImageParser(
                  imageURLorPath: widget.userPhoto,
                ),
                child: commentChild(data),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () async{
                  if (formKey.currentState!.validate()) {

                    FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').doc().set({
                      'user': Hive.box('user').get('phone'),
                      'message': commentController.text,
                      'date': Timestamp.now(),
                    });

                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                sendWidget: Icon(Icons.send_sharp, size: 30, color: blackColor),
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
