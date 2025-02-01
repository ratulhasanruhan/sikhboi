import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/FreeLive.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';
import 'package:sikhboi/screen/PremiumLive.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LiveMain extends StatefulWidget {
  const LiveMain({super.key});

  @override
  State<LiveMain> createState() => _LiveMainState();
}

class _LiveMainState extends State<LiveMain> {
  bool freeForm = false;
  bool premiumForm = false;

  BannerAd? _bannerAd;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController refferController = TextEditingController();

  var box = Hive.box('user');

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
  }

  void loadAd() async {

    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3028551801469741/7298730114',
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

    print(premiumForm);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          const SizedBox(height: 5),
          const Text(
            '"শিখবোই একাডেমির লাইভ ক্লাসে আপনাকে স্বাগতম"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    if(box.get('free_live') != null){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FreeLive()));
                    }
                    else{
                      setState(() {
                        premiumForm = false;
                        freeForm = !freeForm;
                      });
                    }
                  },
                  child: const Text(
                    'Free Live',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
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
                  onPressed: () {},
                  child: AnimatedTextKit(
                    onTap: () async{
                      if(box.get('premium_live') != null){
                        await FirebaseFirestore.instance.collection('admin').doc('premium_live').collection('user').doc(box.get('premium_live')).get().then((value) {
                          if(value['verified']){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumLive()));
                          }
                          else{
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.error(message: "আপনার পেমেন্টটি পর্যালোচনায় রয়েছে। অতি শীঘ্রই আপনাকে এক্সেস দেয়া হবে। ধন্যবাদ।"),
                            );
                          }
                        });
                      }
                      else{
                        setState(() {
                          freeForm = false;
                          premiumForm = !premiumForm;
                        });
                      }
                    },
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Premium Live',
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        colors: [
                          Colors.white,
                          Colors.grey,
                          Colors.red,
                          Colors.white,
                        ],
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),


          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: freeForm ? 480 : 0,
              child: freeForm
                  ? Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: boldRed,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Text(
                          'ফ্রি লাইভে যুক্ত হতে আপনার তথ্য দিন',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'আপনার নাম লিখুন',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: InputDecoration(
                          label: Text('নাম'),
                          fillColor: Color(0xFFF5F3F4),
                          isDense: true,
                          filled: true,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'আপনার নাম লিখুন';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'আপনার ফোন নাম্বার লিখুন',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: InputDecoration(
                          label: Text('নাম্বার'),
                          fillColor: Color(0xFFF5F3F4),
                          filled: true,
                          isDense: true,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'আপনার ফোন নাম্বার লিখুন';
                          } else if (value.length < 11) {
                            return 'আপনার সঠিক ফোন নাম্বার লিখুন';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'আপনার ইমেইল লিখুন',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text('ইমেইল'),
                          fillColor: Color(0xFFF5F3F4),
                          filled: true,
                          isDense: true,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'আপনার ইমেইল লিখুন';
                          } else if (!value.contains('@')) {
                            return 'আপনার সঠিক ইমেইল লিখুন';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'আপনাকে যে জানিয়েছে তার রেফার কোড দিন',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text('রেফার কোড'),
                          fillColor: Color(0xFFF5F3F4),
                          filled: true,
                          isDense: true,
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: MaterialButton(
                            onPressed: () async{

                              if (_formKey.currentState!.validate()) {
                                if(refferController.text.isNotEmpty){
                                  List referUsers = [];

                                  await FirebaseFirestore.instance.collection('users').where('mycode', isEqualTo: refferController.text.trim()).get().then((value) async{
                                    value.docs.forEach((element) {
                                      referUsers.add(element.data()['phone']);
                                    });
                                  });

                                  if(referUsers.isNotEmpty){
                                    await FirebaseFirestore.instance.collection('users').doc(referUsers[0]).update({
                                      'point' : FieldValue.increment(1),
                                    });
                                  }
                                  else{
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.error(message: "আপনার রেফারেল কোডটি সঠিক নয়।"),
                                    );
                                  }

                                  await FirebaseFirestore.instance.collection('free_live').doc(phoneController.text.trim()).set({
                                    'name': nameController.text,
                                    'phone': phoneController.text,
                                    'email': emailController.text,
                                  }).then((value) {
                                    box.put('free_live', phoneController.text.trim());

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FreeLive()));

                                  });
                                }
                                else{
                                  await FirebaseFirestore.instance.collection('free_live').doc(phoneController.text.trim()).set({
                                    'name': nameController.text,
                                    'phone': phoneController.text,
                                    'email': emailController.text,
                                  }).then((value) {
                                    box.put('free_live', phoneController.text.trim());

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => FreeLive()));

                                  });
                                }

                              }

                            },
                            color: boldRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 40,
                            ),
                            child: const Text(
                              'সাবমিট',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  :SizedBox(),
          ),

          if(premiumForm)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset(
                  'assets/gold.json',
                ),

                Text(
                  '৫০০০/-',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'প্রিমিয়াম ফ্রীলান্সিং লাইভ ক্লাসে যুক্ত হতে আপনার পেমেন্ট সম্পন্ন করুন।',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                          amount: 5000,
                          subscription: false,
                          reason: 'live'))
                      );
                    },
                    child: Text(
                      'পেমেন্ট সম্পন্ন করুন',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: boldRed,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),

              ],
            ),

          SizedBox(
            height: 28,
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
    );
  }
}
