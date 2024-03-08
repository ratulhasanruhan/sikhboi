import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:jitsi_meet_v1/feature_flag/feature_flag.dart';
import 'package:jitsi_meet_v1/jitsi_meet.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/LiveWaiting.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:youtube_metadata/youtube.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as player;
import '../utils/colors.dart';
import 'PlayVideo.dart';
import 'package:shimmer/shimmer.dart';

class FreeLive extends StatefulWidget {
  const FreeLive({super.key});

  @override
  State<FreeLive> createState() => _FreeLiveState();
}

class _FreeLiveState extends State<FreeLive> {
  DocumentSnapshot? user;
  var box = Hive.box('user');

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  getUserData() async {
    user = await FirebaseFirestore.instance.collection('free_live').doc(box.get('free_live')).get();
    return user;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'ফ্রি লাইভ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admin').doc('live').snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: EdgeInsets.all(12.r),
              children: [
                const SizedBox(height: 5),
                 Text(
                  'প্রিয় শিক্ষার্থী,\nফ্রীলান্সিং লাইভ ক্লাস প্রতিদিন ${DateFormat('hh:mm:a').format(snapshot.data['time'].toDate())} টায় শুরু হয়।\nযথাসময়ে উপস্থিত থাকার জন্য অনুরোধ করা হলো। ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: boldRed,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                  ),
                  onPressed: () async{
                    if(DateTime.now().isAfter(DateTime.parse(snapshot.data['time'].toDate().toString()))) {
                      try {
                        FeatureFlag featureFlag = FeatureFlag();
                        featureFlag.welcomePageEnabled = false;

                        var options = JitsiMeetingOptions(room: snapshot.data['meeting_id'])
                          ..userDisplayName = user!['name']
                          ..userEmail = user!['email'];

                        await JitsiMeet.joinMeeting(options);
                      } catch (error) {
                        debugPrint("error: $error");
                      }
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LiveWaiting(duration: DateTime.parse(snapshot.data['time'].toDate().toString()).difference(DateTime.now()),)));
                    }
                  },
                  child: AnimatedTextKit(
                    onTap: () async{
                      if(DateTime.now().isAfter(DateTime.parse(snapshot.data['time'].toDate().toString())))
                        try {
                          FeatureFlag featureFlag = FeatureFlag();
                          featureFlag.welcomePageEnabled = false;

                          var options = JitsiMeetingOptions(room: snapshot.data['meeting_id'])
                            ..userDisplayName = user!['name']
                            ..userEmail = user!['email'];

                          await JitsiMeet.joinMeeting(options);
                        } catch (error) {
                          debugPrint("error: $error");
                        }
                      else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveWaiting(duration: DateTime.parse(snapshot.data['time'].toDate().toString()).difference(DateTime.now()))));
                      }
                    },
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Join Live',
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
                const SizedBox(height: 18),

                Text(
                  "Promo Video:",
                  style: TextStyle(
                    color: boldRed,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder(
                    future: YoutubeMetaData.getData(snapshot.data['free_promo']),
                    builder: (context,AsyncSnapshot future) {
                      if(future.hasData){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => PlayVideo(
                                videoId: player.YoutubePlayer.convertUrlToId(snapshot.data['free_promo'])!,
                                title: future.data.title,
                                description: future.data.description,))));
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 170.h,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.35),
                                      blurRadius: 5,
                                      spreadRadius: 3,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      future.data.thumbnailUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.play_circle_filled_outlined,
                                  color: Colors.red.withOpacity(0.7),
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          height: 170.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.red,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 5,
                                  spreadRadius: 3,
                                  offset: Offset(0, 3),
                                )
                              ],
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/logo_h.png',
                                ),
                                fit: BoxFit.cover,
                              )
                          ),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_filled_outlined,
                              color: Colors.red,
                              size: 70,
                            ),
                          ),
                        ),
                      );
                    }
                ),

                SizedBox(
                  height: 28.h,
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(
              color: boldRed,
            ),
          );
        }
      ),
    );
  }
}
