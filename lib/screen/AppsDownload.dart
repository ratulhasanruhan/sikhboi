
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AppsDownload extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const AppsDownload({super.key, required this.documentSnapshot});

  @override
  State<AppsDownload> createState() => _AppsDownloadState();
}

class _AppsDownloadState extends State<AppsDownload> {

  BannerAd? _bannerAd;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
  }

  void loadAd() async {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/9521438894',
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
        title: Text(widget.documentSnapshot['name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25,),
              Image.network(widget.documentSnapshot['logo'], height: 200, width: 200,),
              const SizedBox(height: 25,),

              widget.documentSnapshot['video'] != ''
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      await launchUrl(Uri.parse(widget.documentSnapshot['video']), mode: LaunchMode.externalNonBrowserApplication);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: boldRed,
                    ),
                    child: const Text(
                      'Tutorial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      await launchUrl(Uri.parse(widget.documentSnapshot['link']), mode: LaunchMode.externalApplication);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: boldRed,
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
                  :ElevatedButton(
                onPressed: () async{
                  await launchUrl(Uri.parse(widget.documentSnapshot['link']), mode: LaunchMode.externalApplication);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: boldRed,
                ),
                child: const Text(
                  'Download',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
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
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
