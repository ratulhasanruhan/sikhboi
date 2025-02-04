import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikhboi/screen/AddPost.dart';
import 'package:sikhboi/screen/Comments.dart';
import 'package:sikhboi/screen/MessageList.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/time_difference.dart';
import 'package:sikhboi/widgets/loginPermission.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/assets_path.dart';
import 'Profile.dart';


class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with TickerProviderStateMixin{
  int noticeLength = 0;

  FirebaseFirestore database = FirebaseFirestore.instance;
  var user = Hive.box('user').get('phone');

  bool onlyVideo = false;

  @override
  Widget build(BuildContext context) {

    var query = onlyVideo
        ? database.collection('posts').where('isVideo', isEqualTo: true).orderBy('time', descending: true).snapshots()
        : database.collection('posts').orderBy('time', descending: true).snapshots();

    return Scaffold(
      backgroundColor: backGreen,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: color2dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/mini_icon.png',
                          height: 35,
                          width: 35,
                          color: Colors.white,
                        ),
                        Text(
                          'Social Site',
                          style: TextStyle(
                            color: Color(0xFFB3D891),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                   Row(
                     children: [
                       IconButton(
                           onPressed: (){

                           },
                           iconSize: 30,
                           icon: Badge(
                             isLabelVisible: noticeLength == 0 ? false : true,
                             label: Text(
                               noticeLength.toString(),
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 12,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             backgroundColor: Colors.redAccent,
                             child: Icon(
                               Icons.notifications_active_rounded,
                               color: Color(0xFFB3D891),
                             ),
                           )
                       ),
                       Container(
                         margin: EdgeInsets.only(right: 8),
                         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                         decoration: BoxDecoration(
                           color: primaryColor,
                           borderRadius: BorderRadius.circular(16),
                         ),
                         child: Row(
                           children: [
                              StreamBuilder(
                                 stream: database.collection('users').doc(user).snapshots(),
                                 builder: (context,AsyncSnapshot snapshot) {
                                   if(snapshot.hasData){
                                     return InkWell(
                                       onTap: () {
                                         Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                                       },
                                       child: Row(
                                         children: [
                                           RichText(
                                             text: TextSpan(
                                               children: [
                                                 TextSpan(
                                                   text: '${snapshot.data['point']}.00',
                                                   style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 16,
                                                   ),
                                                 ),
                                                 TextSpan(
                                                   text: 'Pt.',
                                                   style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 10,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                           Icon(
                                             Icons.person_pin,
                                             color: Colors.white,
                                           )
                                         ],
                                       ),
                                     );
                                   }
                                   return const Text(
                                     '000',
                                     style: TextStyle(
                                       color: Colors.white,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   );
                                 }
                             )
                           ],
                         ),
                       )
                     ],
                   )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'অভিজ্ঞতা শেয়ার করুন',
                              style: TextStyle(
                                color: Color(0xFFB3D891),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async{
                            setState(() {
                              onlyVideo = !onlyVideo;
                            });
                          },
                          icon: Icon(
                            Icons.ondemand_video_rounded,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            await launch('https://www.facebook.com/groups/support.sikhboi/?ref=share&mibextid=NSMWBT');
                          },
                          icon: Icon(
                            Icons.groups,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MessageList()));
                          },
                          icon: Icon(
                            Icons.mark_chat_unread_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ]
                )
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: query,
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                          height: 5,
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
    );
  }
}
