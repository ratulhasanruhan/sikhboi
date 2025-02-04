import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/utils/colors.dart';

class Dictionary extends StatefulWidget {
  final String type;
  const Dictionary({Key? key, required this.type}) : super(key: key);

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  BannerAd? _bannerAd;

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
      adUnitId: 'ca-app-pub-3028551801469741/1797754328',
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

  int day_index = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.type);
    return Scaffold(
      backgroundColor: backGreen,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView(
          children: [
            Text(
              widget.type == 'freelance_dictionary'
                  ? '৩০ দিনের বায়ার এবং ফ্রিল্যান্সারের কথাবার্তার মডিউল সাজানো রয়েছে।\nপ্রথম ৩ দিন ফ্রি ব্যবহার করতে পারবেন। তারপরের ক্লাশ গুলো মাত্র ১০০ টাকা ।\n১৫০০ পয়েন্ট দিয়ে কিনতে পারবেন।'
                  : 'প্রতিদিন ১০ টি করে শব্দার্থ মুখস্ত করো, ২ মাস পর যা ৬০০ শব্দের ভান্ডারে পরিনত হবে।\nইংরেজিতে কথা বলার জন্য এটাই যথেষ্ঠ!\nমনে রাখবে, ক্ষুদ্র ক্ষুদ্র বালুকনা থেকেই দীপের সৃষ্টি হয়!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color2dark,
                fontSize: 12,
                fontFamily: 'Ador',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection(widget.type).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print( 'DATA: ' + snapshot.data!.size.toString());
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Day - ${day_index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: greenish,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance.collection(widget.type).doc(snapshot.data!.docs[day_index].id).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> words){
                                if (words.hasData) {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: words.data?['words'].length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    words.data!['words'][index],
                                                    style: TextStyle(
                                                      color: color2dark,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    print(index);

                                                    if((words.data!.data() as Map<String, dynamic>).containsKey('sentences')){
                                                      if(words.data!['sentences'].length < index+1){
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'এই শব্দের জন্য কোন বাক্য নেই!',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            backgroundColor: color2dark,
                                                          ),
                                                        );
                                                        return;
                                                      }
                                                      else{

                                                        showModalBottomSheet(
                                                            context: context,
                                                            backgroundColor: color2dark,
                                                            builder: (BuildContext context) {
                                                              return SizedBox(
                                                                height: MediaQuery.sizeOf(context).height * 0.45,
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        words.data!['words'][index],
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 20,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      color: Colors.white,
                                                                      thickness: 1,
                                                                    ),
                                                                    ListView.separated(
                                                                      shrinkWrap: true,
                                                                      itemCount: words.data!['sentences'][index]['english'].length,
                                                                      separatorBuilder: (BuildContext context, int s_index) {
                                                                        return SizedBox(
                                                                          height: 8,
                                                                        );
                                                                      },
                                                                      itemBuilder: (BuildContext context, int s_index) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                                                          child: Row(
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                '${s_index + 1}. ',
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    words.data!['sentences'][index]['english'][s_index],
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    words.data!['sentences'][index]['bangla'][s_index],
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontSize: 18,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      }
                                                    }
                                                    else{
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'এই শব্দের জন্য কোন বাক্য নেই!',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          backgroundColor: color2dark,
                                                        ),
                                                      );
                                                      return;
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: color2dark,
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'বাক্য তৈরী',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down_sharp,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          day_index > 0 ?
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    day_index--;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_circle_left_rounded,
                                                  color: primaryColor,
                                                  size: 30,
                                                ),
                                              )
                                              : SizedBox(),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          day_index < snapshot.data!.docs.length - 1 ?
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    day_index++;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.arrow_circle_right_rounded,
                                                  color: primaryColor,
                                                  size: 30,
                                                ),
                                              )
                                              : SizedBox(),
                                        ],
                                      )
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }
                          ),
                        )
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
            ),
            SizedBox(
              height: 18,
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
      )
    );
  }
}
