import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:sikhboi/screen/Dictionary.dart';
import 'package:sikhboi/screen/LearnChat.dart';
import 'package:sikhboi/screen/QuizScreen.dart';
import 'package:sikhboi/utils/assets_path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/colors.dart';

class SpokenEnglish extends StatefulWidget {
  const SpokenEnglish({super.key});

  @override
  State<SpokenEnglish> createState() => _SpokenEnglishState();
}

class _SpokenEnglishState extends State<SpokenEnglish> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: Container(
          decoration: BoxDecoration(
            color: color2dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Image.asset(
                                AssetsPath.translate,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Spoken English',
                              style: TextStyle(
                                color: Color(0xFFB3D891),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'জিজ্ঞাসা করুন এবং শিখুন',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, top: 2, bottom: 2, right: 2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await launch('https://www.facebook.com/sikhboi');
                        },
                        child: Row(
                          children: [
                            Text(
                              'Support Group',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              margin: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.facebook_outlined,
                                color: Colors.blueAccent,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ButtonsTabBar(
              backgroundColor: primaryColor,
              borderWidth: 1.5,
              borderColor: primaryColor,
              labelSpacing: 15,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              unselectedBorderColor: primaryColor,
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              buttonMargin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              unselectedBackgroundColor: backGreen,
              unselectedLabelStyle: TextStyle(
                color: color2dark,
                fontWeight: FontWeight.bold,
              ),
              // Add your tabs here
              tabs: [
                Tab(
                  text: 'Chat Bot',
                ),
                Tab(
                  text: 'Vocabulary',
                ),
                Tab(
                  text: 'Quiz',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  LearnChat(),
                  Dictionary(),
                  QuizScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
