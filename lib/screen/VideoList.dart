import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/Learning.dart';
import 'package:sikhboi/screen/PlayVideo.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/yt_details.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoList extends StatefulWidget {
  const VideoList({required this.catId, Key? key}) : super(key: key);
  final String catId;

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  InterstitialAd? _interstitialAd;
  YoutubePlayerController controller = YoutubePlayerController();
  var box = Hive.box('courses');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  void loadAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3028551801469741/4807061048',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

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
        backgroundColor: color2dark,
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        primary: true,
        shrinkWrap: true,
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

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: YoutubePlayer(
                        controller: controller,
                      ),
                    ),
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
          SizedBox(
            height: 10,
          ),
          FirestoreListView(
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            query: FirebaseFirestore.instance.collection('course').doc(widget.catId).collection('video').orderBy('name', descending: false),
            itemBuilder: (context, snapshot){
              var data = snapshot.data();

              return Card(
                color: backGreen,
                elevation: 0,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: ()async{
                    controller.close();
                    controller.mute();
                    
                    box.values.contains(data['name']) ? null : box.add(data['name']);
                    box.values.contains(data['name']) ? null : _interstitialAd!.show();

                    await getDetail('https://www.youtube.com/watch?v=' + data['youtube']).then((metaData) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayVideo(
                        title: metaData['title'],
                        videoId: data['youtube'],
                        description: metaData['title'],
                        catId: widget.catId,
                      )));
                    });

                  },
                  title: Text(
                    data['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                     box.values.contains(data['name']) ? FeatherIcons.checkCircle : FeatherIcons.circle,
                    color: box.values.contains(data['name']) ? Color(0xFF0B7C69) : Colors.grey,
                  ),
                  leading: Icon(
                    Icons.play_circle,
                    color: box.values.contains(data['name']) ? Color(0xFF0B7C69) : Color(0xFFB9DAD3),
                    size: 42,
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
