import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/HomeVideoPlayer.dart';
import 'package:sikhboi/screen/NoticeScreen.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/getVideoUrl.dart';
import 'package:sikhboi/utils/yt_details.dart';
import 'package:sikhboi/widgets/loginPermission.dart';
import 'Profile.dart';
import 'package:shimmer/shimmer.dart';


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
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeScreen()));
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
                      color: searBox ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.search,
                      color: searBox ? Colors.white : color2dark,
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
                      color: searchText == '' ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "All",
                      style: TextStyle(
                        color: searchText == '' ? Colors.white : color2dark,
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
                      color: searchText == 'Soft Skill' ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Soft Skill",
                      style: TextStyle(
                        color: searchText == 'Soft Skill' ? Colors.white : color2dark,
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
                      color: searchText == 'Hard Skill' ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Hard Skill",
                      style: TextStyle(
                        color: searchText == 'Hard Skill' ? Colors.white : color2dark,
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
                      color: searchText == 'Ai Tools' ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Ai Tools",
                      style: TextStyle(
                        color: searchText == 'Ai Tools' ? Colors.white : color2dark,
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
                      color: searchText == 'Event' ? primaryColor : light_green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Event",
                      style: TextStyle(
                        color: searchText == 'Event' ? Colors.white : color2dark,
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
          vertical: 16,
        ),
        children: [

          searBox
          ? Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TextField(
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
            ),
          )
          : SizedBox(),

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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
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
                                            color: Colors.teal,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                future.data['thumbnail_url'],
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
                                            ),
                                            child: Text(
                                              snapshot.data.docs[index]['duration'] ?? '00:00',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                              'assets/launcher.png',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Flexible(
                                            child: Text(
                                              future.data['title'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,  // Lighter base color
                              highlightColor: Colors.white,  // Bright highlight
                              child: Container(
                                width: 350,
                                height: 200,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Title Line
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 160,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(height: 10),
                                    // Subtitle Line
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 15,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    }
                );
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,  // Lighter base color
                highlightColor: Colors.white,  // Bright highlight
                child: Container(
                  width: 350,
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title Line
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 10),
                      // Subtitle Line
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 15,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}