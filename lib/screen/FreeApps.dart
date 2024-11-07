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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  void loadAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-7656295061287292/3154036780",
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Free Apps'),
          centerTitle: true,
        ),
        body: FirestoreListView(
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
        )
    );
  }
}
