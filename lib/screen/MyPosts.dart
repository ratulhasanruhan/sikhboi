import 'package:better_player/better_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikhboi/screen/Comments.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/time_difference.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {

  FirebaseFirestore database = FirebaseFirestore.instance;
  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        centerTitle: true,
      ),
      body: FirestoreListView(
          padding: EdgeInsets.symmetric(horizontal: 8,),
          query: FirebaseFirestore.instance.collection('posts').where('user', isEqualTo: user).orderBy('time', descending: true),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, snapshot){

            var data = snapshot.data();

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: database.collection('users').doc(data['user']).snapshots(),
                        builder: (context,AsyncSnapshot user) {
                          if(user.hasData){
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    user.data['image']),
                              ),
                              title: Text(user.data['name']),
                              subtitle: Text(calculateTimeDifference(startDate: data['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                              trailing: InkWell(
                                onTap: () async{
                                  await FirebaseStorage.instance.refFromURL(data['image']).delete().then((value) {
                                    database.collection('posts').doc(snapshot.id).delete().then((value) {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.success(
                                          message: 'Post Deleted',
                                        ),
                                      );
                                    });
                                  });
                                },
                                  child: Icon(FeatherIcons.trash2, color: blackColor,)
                              ),
                            );
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/avatar.png'
                              ),
                            ),
                            title: Text('.....'),
                            subtitle: Text(calculateTimeDifference(startDate: data['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                          );
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        data['description'],
                        style: GoogleFonts.poppins(),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    data['isVideo']
                        ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: BetterPlayer.network(
                        data['image'],
                        betterPlayerConfiguration: BetterPlayerConfiguration(
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    )
                        : Image.network(
                      data['image'],
                      height: 270,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder(
                            stream: database.collection('posts').doc(snapshot.id).collection('likes').snapshots(),
                            builder: (context,AsyncSnapshot likeSnap) {
                              if(likeSnap.hasData){
                                var likeData = likeSnap.data.docs;

                                return Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async{
                                        if(likeData.any((element) => element.id == user)){
                                          await database.collection('posts').doc(snapshot.id).collection('likes').doc(user).delete();

                                          if(data['isVideo']){
                                            await database.collection('users').doc(data['user']).update({
                                              'point' : FieldValue.increment(-1)
                                            });
                                          }
                                        }else{
                                          await database.collection('posts').doc(snapshot.id).collection('likes').doc(user).set({});

                                          if(data['isVideo']){
                                            await database.collection('users').doc(data['user']).update({
                                              'point' : FieldValue.increment(1)
                                            });
                                          }
                                        }
                                      },
                                      icon: likeData.any((element) => element.id == user)
                                          ? const Icon(Icons.favorite, color: Colors.red,)
                                          : const Icon(FeatherIcons.heart),
                                    ),
                                    InkWell(
                                      onTap: () async{
                                        showDialog(
                                            context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                  title: Row(
                                                    children: [
                                                      const Text('Likes'),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                        size: 20,
                                                      )
                                                    ],
                                                  ),
                                                  content: Container(
                                                    width: double.maxFinite,
                                                    child: ListView(
                                                      shrinkWrap: true,
                                                      children: [
                                                        for(var i in likeData)
                                                          StreamBuilder(
                                                              stream: database.collection('users').doc(i.id).snapshots(),
                                                              builder: (context,AsyncSnapshot uLike) {
                                                                if(uLike.hasData){
                                                                  return ListTile(
                                                                    leading: CircleAvatar(
                                                                      backgroundImage: NetworkImage(
                                                                          uLike.data['image']),
                                                                    ),
                                                                    title: Text(uLike.data['name']),
                                                                  );
                                                                }
                                                                return ListTile(
                                                                  leading: CircleAvatar(
                                                                    backgroundImage: AssetImage(
                                                                        'assets/avatar.png'
                                                                    ),
                                                                  ),
                                                                  title: Text('.....'),
                                                                );
                                                              }
                                                          )

                                                      ],
                                                    ),
                                                  )
                                              );
                                            }
                                        );
                                      },
                                      child: Text(likeData.length.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return IconButton(
                                onPressed: () async{
                                  Share.share(data['description'], subject: 'Sikhboi');
                                },
                                icon: const Icon(FeatherIcons.heart),
                              );
                            }
                        ),
                        IconButton(
                          onPressed: () async{
                            await database.collection('users').doc(user).get().then((value) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(
                                postId: snapshot.id,
                                userPhoto: value['image'],
                                postUser: data['user'],
                              )));
                            });
                          },
                          icon: const Icon(FeatherIcons.messageCircle),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(FeatherIcons.share2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
