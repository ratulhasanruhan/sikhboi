import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sikhboi/utils/colors.dart';
import 'DictionaryDetails.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({Key? key}) : super(key: key);

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
    return Scaffold(
      backgroundColor: backGreen,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ListView(
          children: [
            Text(
              'প্রতিদিন ১০ টি করে শব্দার্থ মুখস্ত করো, ২ মাস পর যা ৬০০ শব্দের ভান্ডারে পরিনত হবে।\nইংরেজিতে কথা বলার জন্য এটাই যথেষ্ঠ!\nমনে রাখবে, ক্ষুদ্র ক্ষুদ্র বালুকনা থেকেই দীপের সৃষ্টি হয়!',
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
                stream: FirebaseFirestore.instance.collection('dictionary').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs);
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
                              stream: FirebaseFirestore.instance.collection('dictionary').doc(snapshot.data!.docs[day_index].id).collection('word').snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> words){
                                if (words.hasData) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: words.data!.docs.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => DictionaryDetails(name: words.data!.docs[index]['name'], id: words.data!.docs[index].id,)));
                                          },
                                          title: Text(
                                            words.data!.docs[index]['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                              fontSize: 20,
                                            ),
                                          ),
                                          subtitle: Text(words.data!.docs[index]['title']),
                                          trailing: Image.network(words.data!.docs[index]['icon']),
                                        ),
                                      );
                                    },
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

            /*FirestoreListView(
              padding: EdgeInsets.all(8),
              query: FirebaseFirestore.instance.collection('dictionary'),
              itemBuilder: (BuildContext context,  snapshot) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DictionaryDetails(name: snapshot['name'], id: snapshot.id,)));
                    },
                    title: Text(
                        snapshot['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(snapshot['title']),
                    trailing: Image.network(snapshot['icon']),
                  ),
                );
              },
            ),*/
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
