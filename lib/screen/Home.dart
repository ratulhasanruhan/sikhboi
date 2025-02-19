import 'package:flutter/material.dart';
import 'package:sikhboi/screen/Ecom.dart';
import 'package:sikhboi/screen/Freelance.dart';
import 'package:sikhboi/screen/HomeScreen.dart';
import 'package:sikhboi/screen/LearnChat.dart';
import 'package:sikhboi/screen/LearningType.dart';
import 'package:sikhboi/screen/SocialScreen.dart';
import 'package:sikhboi/screen/SpokenEnglish.dart';
import 'package:sikhboi/utils/assets_path.dart';

import '../utils/colors.dart';
import 'FreelanceOnboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    /*InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then((_) {
          InAppUpdate.completeFlexibleUpdate().then((_) {
            print('Update completed successfully');
          }).catchError((e) {
            print('Update failed to complete: $e');
          });
        }).catchError((e) {
          print('Update failed to start: $e');
        });
      }
    });*/
  }


  @override
  Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: backGreen,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.jumpToPage(index);
                });
              },
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              iconSize: 38,
              items: [
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.home,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 0
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.course,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 1
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Course',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.translate,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 2
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Translate',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.social,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 3
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Social',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.freelance,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 4
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Freelance',
                ),
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      Image.asset(
                        AssetsPath.ecom,
                        width: 38,
                        height: 38,
                      ),
                      _selectedIndex == 5
                          ? Container(
                              height: 5,
                              width: 5,
                              decoration: BoxDecoration(
                                color: color2,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  label: 'Ecom',
                ),
              ],
              selectedItemColor: color2,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: greenish,
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              HomeScreen(),
              LearningType(),
              SpokenEnglish(),
              SocialScreen(),
              FreelanceOnboard(),
              Ecom()
            ],
          ),
    );
  }
}
