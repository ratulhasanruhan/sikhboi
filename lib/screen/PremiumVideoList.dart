import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/colors.dart';
import 'PremiumPlayVideo.dart';

class PremiumVideoList extends StatefulWidget {
  String catId;
  PremiumVideoList({required this.catId, Key? key}) : super(key: key);

  @override
  State<PremiumVideoList> createState() => _PremiumVideoListState();
}

class _PremiumVideoListState extends State<PremiumVideoList> {

  var user = Hive.box('user').get('phone');
  bool isSubscribed = false;

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection('paid_course').doc(widget.catId).collection('viewers').get().then((value) {
      value.docs.forEach((element) {
        if(element.id == user){
          setState(() {
            isSubscribed = true;
          });
        }
      });
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
              widget.catId,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          primary: true,
          shrinkWrap: true,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('paid_course').doc(widget.catId).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: snapshot.data['intro'],
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  height: 200.h,
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Free Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ]
                )
                  ),
                );
              }
            ),
            SizedBox(
              height: 10.h,
            ),
            FirestoreListView(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              query: FirebaseFirestore.instance.collection('paid_course').doc(widget.catId).collection('video').orderBy('name', descending: false),
              itemBuilder: (context, snapshot){
                var data = snapshot.data();

                return Card(
                  color: Colors.red,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    onTap: ()async{

                     if(isSubscribed){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlayVideo(videoId: data['youtube'], link: data['link'], name: data['name'],)));
                     }

                     else{
                       showDialog(
                           context: context,
                           builder: (context){
                             return AlertDialog(
                               backgroundColor: Colors.white,
                               title: Lottie.asset(
                                   'assets/premium.json',
                                    height: 100,
                               ),
                               content: StreamBuilder(
                                 stream: FirebaseFirestore.instance.collection('paid_course').doc(widget.catId).snapshots(),
                                 builder: (context,AsyncSnapshot snapshot) {
                                   if(snapshot.hasData){
                                     return Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Text(snapshot.data['name'],
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                           fontSize: 16,
                                           fontWeight: FontWeight.w600,
                                         ),),
                                         Text(snapshot.data['title'],
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                           fontSize: 16,
                                         ),),
                                         const SizedBox(height: 10,),
                                          Text('কোর্সটি দেখার জন্য পে করুন-',
                                            textAlign: TextAlign.center,
                                          ),
                                         Text(snapshot.data['price'].toString() + ' ৳',
                                           textAlign: TextAlign.center,
                                           style: TextStyle(
                                             fontSize: 24,
                                             fontWeight: FontWeight.bold,
                                           ),),
                                          const SizedBox(height: 10,),
                                          ElevatedButton(
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(amount: snapshot.data['price'], subscription: true, reason: 'course',)));
                                            },
                                            child: Text(
                                                'পেমেন্ট করুন',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                            ),
                                          ),
                                       ],
                                     );
                                   }
                                   return Text('Loading...');
                                 }
                               ),
                             );
                           }
                       );
                     }


                    },
                    title: Text(
                      data['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      isSubscribed ? FeatherIcons.arrowRight : FeatherIcons.lock,
                      color: Colors.white,
                    ),
                    leading: const Icon(
                      FeatherIcons.playCircle,
                      color: Colors.white,
                    ),
                    minLeadingWidth: 0,
                  ),
                );
              },
            ),
          ],
        )
    );
  }
}
