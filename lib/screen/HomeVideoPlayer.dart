import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:sikhboi/screen/VideoList.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../utils/time_difference.dart';

class HomePlayVideo extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String? catId;
  final String id;
  const HomePlayVideo({required this.videoId, required this.title, required this.description, this.catId, Key? key, required this.id}) : super(key: key);

  @override
  State<HomePlayVideo> createState() => _HomePlayVideoState();
}

class _HomePlayVideoState extends State<HomePlayVideo> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                decoration: new BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.all(Radius.circular(50))),
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
              ),
              title: Text(
                data[i]['message'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(calculateTimeDifference(startDate: data[i]['date'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago', style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                YoutubePlayer(
                    controller: YoutubePlayerController.fromVideoId(
                      videoId: widget.videoId,
                      autoPlay: true,
                      params: YoutubePlayerParams(
                        showControls: true,
                      ),
                    ),
                ),
         Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
             ? Container()
             : Column(
                   children: [
                     IconButton(
                         onPressed: (){
                           if(widget.catId == null) {
                             Navigator.pop(context);
                           } else {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(catId: widget.catId!,)));
                           }
                         },
                         icon: const Icon(Icons.arrow_back_ios)
                     ),
                     Text(
                       widget.title,
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       widget.description,
                       style: const TextStyle(
                         fontSize: 16,
                       ),
                       maxLines: 2,
                       overflow: TextOverflow.fade,
                     ),
                   ],
                 ),
         ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('home_video').doc(widget.id).collection('comment').snapshots(),
                builder: (context,AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    var data = snapshot.data.docs;

                    return Container(
                      padding: EdgeInsets.only(bottom: WidgetsBinding.instance.window.viewInsets.bottom > 0.0 ? 0 : 40),
                      child: CommentBox(
                        userImage: CommentBox.commentImageParser(
                          imageURLorPath: 'assets/add_avatar.png',
                        ),
                        child: WidgetsBinding.instance.window.viewInsets.bottom > 0.0 ? Container() :commentChild(data),
                        labelText: 'Write a comment...',
                        errorText: 'Comment cannot be blank',
                        withBorder: false,
                        sendButtonMethod: () async{
                          if (formKey.currentState!.validate()) {

                            FirebaseFirestore.instance.collection('home_video').doc(widget.id).collection('comment').doc().set({
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
          )
        ],
      )
    );

  }
}
