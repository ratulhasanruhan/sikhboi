import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/LearnChat.dart';
import 'package:sikhboi/screen/LearningPremium.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import 'Dictionary.dart';
import 'Earning.dart';
import 'Home.dart';
import 'Learning.dart';

class LearningType extends StatefulWidget {
  const LearningType({Key? key}) : super(key: key);

  @override
  State<LearningType> createState() => _LearningTypeState();
}

class _LearningTypeState extends State<LearningType> {

/*
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAd();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  void loadAd() {
    _nativeAd = NativeAd(
        adUnitId: 'ca-app-pub-7656295061287292/8980196698',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.blue,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.white,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }
*/


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: const Text('Learning'),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: blackColor,
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            icon: const Icon(Icons.arrow_back),
          )
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4360AE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Learning()));
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Dictionary()));
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/dictionary.json', height: 90.h),
                        Text(
                          'শব্দার্থ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'ইংরেজি সকল শব্দার্থ শিখুন',
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
                width: 12.w,
              ),
              Expanded(
                child: Card(
                  color: yellish,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LearnChat()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/knowledge.json', height: 90.h),
                        Text(
                          'ইংরেজি',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
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


          /* ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 320, // minimum recommended height
              maxWidth: 400,
              maxHeight: 400,
            ),
            child: AdWidget(ad: _nativeAd!),
          )*/

          ]
      ),
    );
  }
}
