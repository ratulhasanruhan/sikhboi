import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/FreeApps.dart';
import 'package:sikhboi/screen/LearnChat.dart';
import 'package:sikhboi/screen/LearningPremium.dart';
import '../utils/colors.dart';
import 'Dictionary.dart';
import 'Home.dart';
import 'Learning.dart';

class LearningType extends StatefulWidget {
  const LearningType({Key? key}) : super(key: key);

  @override
  State<LearningType> createState() => _LearningTypeState();
}

class _LearningTypeState extends State<LearningType> with SingleTickerProviderStateMixin {

  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
    loadReward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
  }

  void loadReward() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3028551801469741/8788308704',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        // Called when the ad showed the full screen content.
          onAdShowedFullScreenContent: (ad) {},
          // Called when an impression occurs on the ad.
          onAdImpression: (ad) {},
          // Called when the ad failed to show full screen content.
          onAdFailedToShowFullScreenContent: (ad, err) {
            // Dispose the ad here to free resources.
            ad.dispose();
          },
          // Called when the ad dismissed full screen content.
          onAdDismissedFullScreenContent: (ad) {
            // Dispose the ad here to free resources.
            ad.dispose();
          },
          // Called when a click is recorded for an ad.
          onAdClicked: (ad) {});

      debugPrint('$ad loaded.');
      // Keep a reference to the ad so you can show it later.
      _rewardedAd = ad;
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (LoadAdError error) {
    debugPrint('RewardedAd failed to load: $error');
    },
    ),
    );
  }


  void loadAd() async {

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/4142486687',
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        onAdLoaded: (ad) {

        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        title:  Text(
            'Your Courses',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
        ),
        backgroundColor: backGreen,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FreeApps()));
              },
              child: Row(
                children: [
                  Text(
                    'Free Software',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                      margin: EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.download_outlined,
                      color: Colors.redAccent,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
              backgroundColor: primaryColor,
              borderWidth: 1.5,
              borderColor: primaryColor,
              labelSpacing: 15,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              unselectedBorderColor: primaryColor,
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              unselectedBackgroundColor: backGreen,
              unselectedLabelStyle: TextStyle(
                color: color2dark,
                fontWeight: FontWeight.bold,
              ),
              // Add your tabs here
              tabs: [
                Tab(
                  text: 'Free Courses',
                ),
                Tab(
                  text: 'Paid Courses',
                ),
                Tab(
                  icon: Icon(
                      Icons.videocam_rounded,
                    color: Colors.red,
                  ),
                  text: 'Live',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Learning(),
                  LearningPremium(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4360AE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Learning()));
                _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Free Courses',
                          style: GoogleFonts.teko(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'এখানে সবগুলো কোর্স সম্পূর্ণ ফ্রি!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Lottie.asset(
                      'assets/free.json',
                      height: 100,
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF47820),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LearningPremium()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Premium Courses',
                          style: GoogleFonts.teko(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'প্রিমিয়াম মানেই এক্সট্রা সাপোর্ট\nএবং দ্রুত সফলতার দিকে এগিয়ে যাওয়া।',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    Lottie.asset(
                      'assets/badge.json',
                      height: 100,
                      width: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Card(
                  color: Color(0xFF1063A3),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FreeApps()));
                      _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});

                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/download.json', height: 90),
                        Text(
                          'সফটওয়্যার',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'ফ্রি এপস ডাউনলোড',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),


                      ],
                    ),
                  ),

                ),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Card(
                  color: yellish,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LearnChat()));
                      _rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});

                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/knowledge.json', height: 90),
                        Text(
                          'ইংরেজি',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'দ্রুত জড়তা দূর করুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          height: 5,
                        ),


                      ],
                    ),
                  ),

                ),
              ),

            ],

          ),

            SizedBox(
              height: 16,
            ),

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
                : SizedBox(),*/