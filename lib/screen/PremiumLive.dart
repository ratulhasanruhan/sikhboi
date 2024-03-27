import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sikhboi/utils/getVideoUrl.dart';
import 'package:sikhboi/utils/yt_details.dart';
import '../utils/colors.dart';
import 'LiveWaiting.dart';
import 'PlayVideo.dart';
import 'PremiumFIles.dart';

class PremiumLive extends StatefulWidget {
  const PremiumLive({super.key});

  @override
  State<PremiumLive> createState() => _PremiumLiveState();
}

class _PremiumLiveState extends State<PremiumLive> {
  var user = Hive.box('user').get('premium_live');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: boldRed,
        title: const Text(
          'প্রিমিয়াম লাইভ',
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
          stream: FirebaseFirestore.instance.collection('admin').doc('premium_live').snapshots(),
          builder: (context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.all(12),
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'প্রিয় শিক্ষার্থী,\nপরবর্তী ক্লাস ${DateFormat('dd/mm/yyyy -- hh:mm:a').format(snapshot.data['time'].toDate())}',
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
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                    ),
                    onPressed: () async{
                      if(DateTime.now().isAfter(DateTime.parse(snapshot.data['time'].toDate().toString())))
                        try {
                   /*       FeatureFlag featureFlag = FeatureFlag();
                          featureFlag.welcomePageEnabled = false;

                          var options = JitsiMeetingOptions(room: snapshot.data['meeting_id'])
                            ..userDisplayName = user;

                          await JitsiMeet.joinMeeting(options);*/
                        } catch (error) {
                          debugPrint("error: $error");
                        }
                      else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveWaiting(duration: DateTime.parse(snapshot.data['time'].toDate().toString()).difference(DateTime.now()),)));
                      }
                    },
                    child: AnimatedTextKit(
                      onTap: () async{
                        if(DateTime.now().isAfter(DateTime.parse(snapshot.data['time'].toDate().toString())))
                          try {
                           /* FeatureFlag featureFlag = FeatureFlag();
                            featureFlag.welcomePageEnabled = false;

                            var options = JitsiMeetingOptions(room: snapshot.data['meeting_id'])
                              ..userDisplayName = user;

                            await JitsiMeet.joinMeeting(options);*/
                          } catch (error) {
                            debugPrint("error: $error");
                          }
                        else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveWaiting(duration: DateTime.parse(snapshot.data['time'].toDate().toString()).difference(DateTime.now()),)));
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
                      future: getDetail(snapshot.data['promo']),
                      builder: (context,AsyncSnapshot future) {
                        if(future.hasData){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: ((context) => PlayVideo(
                                  videoId: getVideoID(snapshot.data['free_promo']),
                                  title: future.data['title'],
                                  description: future.data['title'],))));
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 170,
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
                            height: 170,
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
                    height: 16,
                  ),
                  Card(
                    elevation: 5,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        'প্রিমিয়াম ফাইল সমূহ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumFiles()));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.file_present,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
