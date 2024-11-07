import 'dart:async';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sikhboi/utils/colors.dart';
import '../controller/QuestionCOntroller.dart';

class EarningQuestion extends StatefulWidget {
  final String day;
  EarningQuestion({Key? key, required this.day}) : super(key: key);

  @override
  State<EarningQuestion> createState() => _EarningQuestionState();
}

class _EarningQuestionState extends State<EarningQuestion> {


  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }


  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
    await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: 'ca-app-pub-7656295061287292/9893306196',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }


  @override
  Widget build(BuildContext context) {
    bool disabled = Provider.of<QuestionController>(context).disabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('earning').doc(widget.day).collection('question').snapshots(),
        builder: (context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: EdgeInsets.all(6),
                        alignment: Alignment.center,
                        child: Text(
                          snapshot.data.docs[index].id,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: listBack[math.Random().nextInt(listBack.length)],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      if (_anchoredAdaptiveAd != null && _isLoaded)
                        StatefulBuilder(
                            builder: (context, setState) {
                              if(index%2==0)
                                return Container(
                                  color: Colors.transparent,
                                  width: _anchoredAdaptiveAd!.size.width.toDouble(),
                                  height: _anchoredAdaptiveAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _anchoredAdaptiveAd!),
                                );
                              else
                                return Container();
                            }
                        ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  );
                }
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),


      /*ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        primary: true,
        children: [
          SizedBox(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('earning').doc(widget.day).collection('question').snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  var data = snapshot.data.docs;

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: PageView.builder(
                      physics: disabled ? NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
                      controller: appinioSwiperController,
                      itemCount: data.length,
                      onPageChanged: (index) {
                        countDownController.restart();
                      },
                      itemBuilder: (context, index){
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          padding: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          child: Text(
                            data[index].id,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: listBack[index % listBack.length],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              }
            ),
          ),

         *//* SizedBox(
            height: 10.h,
          ),

          CircularCountDownTimer(
            duration: 2,
            initialDuration: 0,
            controller: countDownController,
            width: 70.r,
            height: 70.r,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: pinkish,
            fillGradient: null,
            backgroundGradient: null,
            strokeWidth: 8.r,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(
                fontSize: 28,
                color: pinkish,
                fontWeight: FontWeight.bold),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: true,
            onStart: () {
              Future.delayed(Duration.zero, () {
                context.read<QuestionController>().setDisabled(true);
              });
            },
            onComplete: () {

              if (interstitialAd != null) {
                interstitialAd!.show().onError((error, stackTrace) {
                  debugPrint("Error showing Rewarded Video ad: $error");
                  return false;
                });
              }
              else{
                loadInterstitialAd();

              }

              context.read<QuestionController>().setDisabled(false);
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              if (duration.inSeconds == 0) {
                return "Swipe";
              } else {
                return Function.apply(defaultFormatterFunction, [duration]);
              }
            },


          ),*//*
        ],
      )*/
    );
  }
}
