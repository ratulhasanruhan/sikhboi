import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikhboi/screen/AddPost.dart';
import 'package:sikhboi/screen/Comments.dart';
import 'package:sikhboi/screen/MessageList.dart';
import 'package:sikhboi/utils/time_difference.dart';
import 'package:sikhboi/widgets/loginPermission.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with TickerProviderStateMixin{

  FirebaseFirestore database = FirebaseFirestore.instance;
  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user == null || user == ''

          ? Stack(
            children: [
              StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('time', descending: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder(
                                      stream: database.collection('users').doc(snapshot.data.docs[index]['user']).snapshots(),
                                      builder: (context,AsyncSnapshot user) {
                                        if(user.hasData){
                                          return ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8) ),
                                            ),
                                            onTap: () {
                                              loginPermissionDialog(context);
                                            },
                                            leading: CircleAvatar(
                                              child: Text(user.data['name'][0].toString().toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                            ),
                                            title: Text(user.data['name']),
                                            subtitle: Text(calculateTimeDifference(startDate: snapshot.data.docs[index]['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                                          );
                                        }
                                        return ListTile(
                                          leading: CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                          title: Text('.....'),
                                          subtitle: Text(calculateTimeDifference(startDate: snapshot.data.docs[index]['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                                        );
                                      }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      snapshot.data.docs[index]['description'],
                                      style: GoogleFonts.poppins(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  snapshot.data.docs[index]['isVideo']
                                      ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: BetterPlayer.network(
                                      snapshot.data.docs[index]['image'],
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        aspectRatio: 16 / 9,
                                      ),
                                    ),
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: snapshot.data.docs[index]['image'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      StreamBuilder(
                                          stream: database.collection('posts').doc(snapshot.data.docs[index].id).collection('likes').snapshots(),
                                          builder: (context,AsyncSnapshot likeSnap) {
                                            if(likeSnap.hasData){
                                              var likeData = likeSnap.data.docs;

                                              return Row(
                                                children: [
                                                  Icon(FeatherIcons.heart),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  Text(likeData.length.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                            return IconButton(
                                              onPressed: () async{
                                                Share.share(snapshot.data.docs[index]['description'], subject: 'Sikhboi');
                                              },
                                              icon: const Icon(FeatherIcons.heart),
                                            );
                                          }
                                      ),
                                      IconButton(
                                        onPressed: () async{
                                          loginPermissionDialog(context);
                                        },
                                        icon: const Icon(FeatherIcons.messageCircle),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Share.share(snapshot.data.docs[index]['description'], subject: 'Sikhboi');
                                        },
                                        icon: const Icon(FeatherIcons.share2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),

                          ],
                        ),
                      );
                    }
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
        },
      ),
              Positioned(
                top: 34,
                left: 22.w,
                right: 22.w,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(0xFF2D2F94),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Color(0xFF29ACE4),
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () {
                              loginPermissionDialog(context);
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w,),
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Post Your Practise Design',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Color(0xFFFA921B),
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () {
                              loginPermissionDialog(context);
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w,),
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  'Inbox',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ],
          )
          : Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').orderBy('time', descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder(
                                      stream: database.collection('users').doc(snapshot.data.docs[index]['user']).snapshots(),
                                      builder: (context,AsyncSnapshot user) {
                                        if(user.hasData){
                                          return ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8) ),
                                            ),
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context){
                                                    TextEditingController _controller = TextEditingController();

                                                    return AlertDialog(
                                                      title: Text('Message to ${user.data['name']}'),
                                                      content: TextField(
                                                        controller: _controller,
                                                        decoration: InputDecoration(
                                                          hintText: 'Write a message...',
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                        ),
                                                        maxLines: 3,
                                                        minLines: 2,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('Close'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async{
                                                            await database.collection('chat').add({
                                                              'time': Timestamp.now(),
                                                              'user': [
                                                                Hive.box('user').get('phone'),
                                                                snapshot.data.docs[index]['user']
                                                              ],
                                                              'sms' : [
                                                                {
                                                                  'text': _controller.text,
                                                                  'user': Hive.box('user').get('phone'),
                                                                  'time': Timestamp.now(),
                                                                }
                                                              ]
                                                            }).then((value) {
                                                              Navigator.pop(context);
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent')));
                                                            });
                                                          },
                                                          child: const Text('Send'),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            },
                                            leading: CircleAvatar(
                                              child: Text(user.data['name'][0].toString().toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                            ),
                                            title: Text(user.data['name']),
                                            subtitle: Text(calculateTimeDifference(startDate: snapshot.data.docs[index]['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                                          );
                                        }
                                        return ListTile(
                                          leading: CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                          title: Text('.....'),
                                          subtitle: Text(calculateTimeDifference(startDate: snapshot.data.docs[index]['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '')+ ' ago'),
                                        );
                                      }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      snapshot.data.docs[index]['description'],
                                      style: GoogleFonts.poppins(),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  snapshot.data.docs[index]['isVideo']
                                      ? AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: BetterPlayer.network(
                                      snapshot.data.docs[index]['image'],
                                      betterPlayerConfiguration: BetterPlayerConfiguration(
                                        aspectRatio: 16 / 9,
                                      ),
                                    ),
                                  )
                                      : CachedNetworkImage(
                                    imageUrl: snapshot.data.docs[index]['image'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      StreamBuilder(
                                          stream: database.collection('posts').doc(snapshot.data.docs[index].id).collection('likes').snapshots(),
                                          builder: (context,AsyncSnapshot likeSnap) {
                                            if(likeSnap.hasData){
                                              var likeData = likeSnap.data.docs;

                                              return Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async{
                                                      if(likeData.any((element) => element.id == user)){
                                                        await database.collection('posts').doc(snapshot.data.docs[index].id).collection('likes').doc(user).delete();

                                                        /*   await database.collection('users').doc(data['user']).update({
                                                'point' : FieldValue.increment(-1),
                                              });*/

                                                      }else{
                                                        await database.collection('posts').doc(snapshot.data.docs[index].id).collection('likes').doc(user).set({});

                                                        /*  await database.collection('users').doc(data['user']).update({
                                                'point' : FieldValue.increment(1),
                                              });*/

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
                                                                      width: 8.w,
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
                                                                                    child: Text(uLike.data['name'][0].toString().toUpperCase(),
                                                                                      style: GoogleFonts.poppins(
                                                                                        fontWeight: FontWeight.w600,

                                                                                      ),
                                                                                    ),
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
                                                Share.share(snapshot.data.docs[index]['description'], subject: 'Sikhboi');
                                              },
                                              icon: const Icon(FeatherIcons.heart),
                                            );
                                          }
                                      ),
                                      IconButton(
                                        onPressed: () async{

                                          await database.collection('users').doc(user).get().then((value) {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(
                                              postId: snapshot.data.docs[index].id,
                                              userPhoto: value['image'],
                                              postUser: snapshot.data.docs[index]['user'],
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
                            SizedBox(
                              height: 5.h,
                            ),


                            /*StatefulBuilder(
                                  builder: (context, setState) {
                                    if(index%3==0){
                                      return _getAdWidget();
                                    }
                                    return Container();
                                  }
                              )*/

                          ],
                        ),
                      );
                    }
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Positioned(
            top: 34,
            left: 22.w,
            right: 22.w,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                height: 48,
                decoration: BoxDecoration(
                  color: Color(0xFF2D2F94),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      color: Color(0xFF29ACE4),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w,),
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Post Your Practise Design',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Color(0xFFFA921B),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageList()));
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w,),
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              'Inbox',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
}
