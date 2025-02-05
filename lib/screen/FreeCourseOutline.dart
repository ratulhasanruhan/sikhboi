import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'Profile.dart';
import 'VideoList.dart';

class FreeCourseOutline extends StatefulWidget {
  final String catId;
  const FreeCourseOutline({super.key, required this.catId});

  @override
  State<FreeCourseOutline> createState() => _FreeCourseOutlineState();
}

class _FreeCourseOutlineState extends State<FreeCourseOutline> {
  YoutubePlayerController controller = YoutubePlayerController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int noticeLength = 0;
  var box = Hive.box('user');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        backgroundColor: backGreen,
        title: Text(
          'Free Course',
          style: TextStyle(
            color: color2dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
                  color: color2dark,
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
            child: StreamBuilder(
               stream: firestore.collection('users').doc(box.get('phone')).snapshots(),
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
                            ),
          )
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('course').doc(widget.catId).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  controller = YoutubePlayerController.fromVideoId(
                    videoId: snapshot.data['intro'],
                    autoPlay: true,
                    params: const YoutubePlayerParams(
                      showControls: true,
                      showFullscreenButton: true,
                    ),
                  );

                  return YoutubePlayer(
                    controller: controller,
                  );
                }
                return Container(
                  height: 200,
                  color: Colors.black87,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Intro Video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ]
                      )
                  ),
                );
              }
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 14,
                ),
                Text(
                  widget.catId,
                  style: TextStyle(
                    color: color2dark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('course').doc(widget.catId).snapshots(),
                  builder: (context,AsyncSnapshot snapshot) {
                    if(snapshot.hasData){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Created By ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapshot.data['created_by'] ?? 'Sikhboi',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              )),
                          Row(
                            children: [
                              Icon(
                                Icons.watch_later_outlined,
                                size: 18,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                snapshot.data.data() == null ? '0' : snapshot.data.data()['duration'] ?? '00:00:00',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }
                    return const SizedBox();
                  }
                ),
                SizedBox(
                  height: 22,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '৳ ০০',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '100 % off',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                const Text(
                  'কিছু নীতিকথা ▼', // Title
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0), // Add some spacing between title and text
                const Text(
                  'এই কোর্সটি এমন ভাবে সাজানো হয়েছে যাতে আপনি বেসিক থেকে হাতে কলমে শিখতে পারেন। তবে শুধু ভিডিও দেখলেই শিখতে পারবেন না, ভালো ভাবে যে কোন কিছু আয়ত্ত করার জন্য প্রয়োজন প্রচুর প্রাকটিস। এই কোর্সটি এমন ভাবে সাজানো হয়েছে যাতে আপনি বেসিক থেকে হাতে কলমে শিখতে পারেন। তবে শুধু ভিডিও দেখলেই শিখতে পারবেন না, ভালো ভাবে যে কোন কিছু আয়ত্ত করার জন্য প্রয়োজন প্রচুর প্রাকটিস। এই কোর্সটি এমন ভাবে সাজানো হয়েছে যাতে আপনি বেসিক থেকে হাতে কলমে শিখতে পারেন। তবে শুধু ভিডিও দেখলেই শিখতে পারবেন না, ভালো ভাবে যে কোন কিছু আয়ত্ত করার জন্য প্রয়োজন প্রচুর প্রাকটিস!',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(
                  height: 14,
                ),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(catId: widget.catId)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Start Learning',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
