import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/HomeVideoPlayer.dart';
import 'package:sikhboi/screen/LearningType.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/getVideoUrl.dart';
import 'package:sikhboi/utils/yt_details.dart';
import 'package:sikhboi/widgets/loginPermission.dart';
import 'package:skeletons/skeletons.dart';
import 'LiveMain.dart';
import 'Profile.dart';
import 'WithdrawPoints.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var box = Hive.box('user');
  String searchText = '';
  bool searBox = false;

  int noticeLength = 0;

  @override
  void initState() {
    super.initState();

    getNoticeLength();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showBanner();
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (AppLifecycleState.detached == state) {
        box.put('banner', false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  getNoticeLength() async{
    await FirebaseFirestore.instance.collection('notice').get().then((value) {
      setState(() {
        noticeLength = value.docs.length;
      });
    });
  }

  showBanner() async{
    await FirebaseFirestore.instance.collection('admin').doc('home').get().then((value) {
        if(value['home_banner'] != '' && box.get('banner') == false){
          return showDialog(
              context: context,
              builder: (context){
                return Dialog(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(value['home_banner']),
                              fit: BoxFit.cover,
                            )
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                )
                              ]
                          ),
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.close,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
          ).then((value) {
            box.put('banner', true);
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        backgroundColor: backGreen,
        leading: Image.asset('assets/logo.png', height: 40),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){

              },
              iconSize: 30,
              icon: Badge(
                isLabelVisible: noticeLength == 0 ? false : true,
                label: Text(
                  noticeLength.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.redAccent,
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: color2dark,
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                box.get('phone') == '' || box.get('phone') == null
                ? InkWell(
                  onTap: () {
                    loginPermissionDialog(context);
                  },
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '0.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: 'Pt.',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.person_pin,
                        color: Colors.white,
                      )
                    ],
                  ),
                )
                : StreamBuilder(
                  stream: firestore.collection('users').doc(box.get('phone')).snapshots(),
                  builder: (context,AsyncSnapshot snapshot) {
                    if(snapshot.hasData){
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                        },
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${snapshot.data['point']}.00',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Pt.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.person_pin,
                              color: Colors.white,
                            )
                          ],
                        ),
                      );
                    }
                    return const Text(
                        '000',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                )
              ],
            ),
          )
        ],
        leadingWidth: 110,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = !searBox;
                      searchText = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search,
                      color: color2dark,
                      size: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = false;
                      searchText = '';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(
                        color: color2dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = false;
                      searchText = 'Soft Skill';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Soft Skill",
                      style: TextStyle(
                        color: color2dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = false;
                      searchText = 'Hard Skill';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Hard Skill",
                      style: TextStyle(
                        color: color2dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = false;
                      searchText = 'Ai Tools';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Ai Tools",
                      style: TextStyle(
                        color: color2dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      searBox = false;
                      searchText = 'Event';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Event",
                      style: TextStyle(
                        color: color2dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        children: [

          searBox
          ? TextField(
            onChanged: (value){
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'সার্চ করুন',
              fillColor: Color(0xFFF5F3F4),
              isDense: true,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 56,
                minHeight: 45,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
              ),
            ),
          )
          : SizedBox(),

          SizedBox(
            height: 16,
          ),

          StreamBuilder(
            stream: searchText == ''
                    ? FirebaseFirestore.instance.collection('home_video').snapshots()
                    : FirebaseFirestore.instance.collection('home_video').where('title', isGreaterThanOrEqualTo: searchText).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: getDetail(snapshot.data.docs[index]['link']),
                          builder: (context,AsyncSnapshot future) {
                            if(future.hasData){
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  onTap: (){
                                    print(future.data);
                                    Navigator.push(context, MaterialPageRoute(builder: ((context) => HomePlayVideo(
                                        videoId: getVideoID(snapshot.data.docs[index]['link']),
                                        title: future.data['title'],
                                        description: future.data['title'],
                                        id: snapshot.data.docs[index].id,
                                    ))));
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 180,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.red,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.35),
                                            blurRadius: 5,
                                            spreadRadius: 3,
                                            offset: Offset(0, 3),
                                          )
                                        ],
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            future.data['thumbnail_url'],
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_circle_filled_outlined,
                                        color: Colors.red.withOpacity(0.7),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: 170,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.35),
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/logo_h.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.play_circle_filled_outlined,
                                    color: Colors.red,
                                    size: 70,
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }
                );
              }
              return Shimmer(
                  shimmer: ShimmerState(),
                  child: Container(
                    height: 170,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 5,
                            spreadRadius: 3,
                            offset: Offset(0, 3),
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/logo_h.png',
                          ),
                          fit: BoxFit.cover,
                        )
                    ),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_filled_outlined,
                        color: Colors.red,
                        size: 70,
                      ),
                    ),
                  ) ,
              );
            }
          ),


        ],
      ),
    );
  }
}





/*          Row(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Earning()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset('assets/knowledge.json', height: 90.h),
                        Text(
                          'সাধারণ জ্ঞান',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'গুরুত্বপূর্ণ তথ্য জানুন এবং শিখুন',
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
            height: 20.h,
          ),

          _nativeAdIsLoaded ?
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 90, // minimum recommended height
              maxWidth: 400,
              maxHeight: 90,
            ),
            child: AdWidget(ad: _nativeAd!),
          )
          : Container(),

          SizedBox(
            height: 10.h,
          ),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('admin').doc('home').snapshots(),
            builder: (context,AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                var data = snapshot.data;
                return Container(
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            CircleAvatar(
                              child: Image.asset('assets/email.png',
                                  height: 23.r),
                              backgroundColor: waterColor,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Latest',
                                  style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Stay Update',
                                  style: TextStyle(
                                    color: deepColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      data['is_image']
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: CachedNetworkImage(
                          imageUrl: data['image'],
                          errorWidget: (context, url, error) {
                            return const Center(
                              child: Text(
                                  'We do not have latest news today.'),
                            );
                          },
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                            child: YoutubePlayer(
                        controller: YoutubePlayerController.fromVideoId(
                          videoId: data['video'],
                          params: const YoutubePlayerParams(
                            showVideoAnnotations: false,
                            showControls: true,
                            showFullscreenButton: false,
                            strictRelatedVideos: true,
                          ),
                        ),
                        aspectRatio: 16 / 9,
                      ),
                          ),
                    ],
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Image.asset('assets/email.png',
                                height: 23.r),
                            backgroundColor: waterColor,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Latest',
                                style: TextStyle(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                'Stay Update',
                                style: TextStyle(
                                  color: deepColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Text('Welcome to sikhboi',
                      style: const TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          ),*/