import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
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
  RewardedAd? _rewardedAd;

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  void loadRewardAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3028551801469741/2741904985",
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRewardAd();
  }

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
      appBar: AppBar(
        backgroundColor: backGreen,
        elevation: 0,
      ),
      backgroundColor: backGreen,
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
                     Text(
                       widget.title,
                       style: const TextStyle(
                         fontSize: 18,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                     const SizedBox(height: 12),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         ElevatedButton(
                           onPressed: () async {
                             _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                               print('User rewarded: ${reward.amount}');
                             });

                             await launchUrl(Uri.parse('https://www.facebook.com/groups/support.sikhboi/?ref=share&mibextid=NSMWBT'));
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Color(0xFFB3D891),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                             fixedSize: const Size(175, 40),
                           ),
                           child: Row(
                             children: [
                               Container(
                                 padding: const EdgeInsets.all(5),
                                 decoration: BoxDecoration(
                                   color: color2dark,
                                   shape: BoxShape.circle,
                                 ),
                                 child: Icon(
                                   Icons.facebook,
                                   color: Colors.white,
                                   size: 22,
                                 ),
                               ),
                               const SizedBox(width: 5),
                               const Text(
                                 'Support',
                                 style: TextStyle(
                                     color: color2dark,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 20
                                 ),
                               ),
                             ],
                           ),
                         ),
                         ElevatedButton(
                           onPressed: () async {
                             _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                               print('User rewarded: ${reward.amount}');
                             });

                             await FirebaseFirestore.instance.collection('course').doc(widget.catId).collection('video').doc(widget.videoId).get().then((value) {
                               if((value.data() as Map<String, dynamic>).containsKey('file')) {
                                 launchUrl(Uri.parse(value['file']));
                               }else{
                                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                   content: Text('No source file found'),
                                 ));
                               }
                             });
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: primaryColor,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10),
                             ),
                             fixedSize: const Size(182, 40),
                           ),
                           child: Row(
                             children: [
                               Container(
                                 padding: const EdgeInsets.all(5),
                                 decoration: BoxDecoration(
                                   color: color2dark,
                                   shape: BoxShape.circle,
                                 ),
                                 child: Icon(
                                   Icons.file_download_outlined,
                                   color: Colors.white,
                                   size: 22,
                                 ),
                               ),
                               const SizedBox(width: 5),
                               const Text(
                                 'Source File',
                                 style: TextStyle(
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold,
                                     fontSize: 20
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ],
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
