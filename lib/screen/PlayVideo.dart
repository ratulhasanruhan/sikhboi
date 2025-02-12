import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/VideoList.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayVideo extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String? catId;
  const PlayVideo({required this.videoId, required this.title, required this.description, this.catId, Key? key}) : super(key: key);

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;
  late Orientation _currentOrientation;

  YoutubePlayerController _controller = YoutubePlayerController();

  var user = Hive.box('user').get('phone');


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
    loadRewardAd();
    Future.delayed(const Duration(minutes: 1), () {
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        FirebaseFirestore.instance.collection('users').doc(user).update({
          'point': FieldValue.increment(5),
        });
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    loadAd();
  }

  void loadAd() async {

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/7770740500',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) async{

        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

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
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: backGreen,
          appBar: AppBar(
            backgroundColor: backGreen,
          ),
          body: Column(
            children: [
              player,
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        textAlign: TextAlign.start,
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
                              await launchUrl(Uri.parse('https://www.facebook.com/groups/support.sikhboi/?ref=share&mibextid=NSMWBT'));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFB3D891),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: const Size(175, 50),
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
                                    size: 26,
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
                              fixedSize: const Size(182, 50),
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
                                    size: 26,
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
                      const SizedBox(height: 20),
                      _bannerAd != null ?
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      )
                          : SizedBox(),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

  }
}
