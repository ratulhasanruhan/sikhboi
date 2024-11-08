import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/utils/colors.dart';

import 'AppsDownload.dart';

class FreeApps extends StatefulWidget {
  const FreeApps({super.key});

  @override
  State<FreeApps> createState() => _FreeAppsState();
}

class _FreeAppsState extends State<FreeApps> {

  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRewardAd();
    loadAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
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

  void loadAd() async {

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/8208357227',
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
        appBar: AppBar(
          title: const Text('Free Apps'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FirestoreListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                query: FirebaseFirestore.instance.collection('free_apps'),
                itemBuilder: (BuildContext context, DocumentSnapshot documentSnapshot) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: primaryColor,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AppsDownload(documentSnapshot: documentSnapshot)));
                        _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                          print('User rewarded: ${reward.amount}');
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      title: Text(documentSnapshot['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Image.network(documentSnapshot['logo'],height: 35, width: 35,),
                    ),
                  );
                },
              ),
              SizedBox(height: 12,),
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
        )
    );
  }
}
