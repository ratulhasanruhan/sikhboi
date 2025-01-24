import 'package:flutter/material.dart';
import 'package:sikhboi/screen/Ecom.dart';
import 'package:sikhboi/screen/Freelance.dart';
import 'package:sikhboi/screen/HomeScreen.dart';
import 'package:sikhboi/screen/LearnChat.dart';
import 'package:sikhboi/screen/LearningType.dart';
import 'package:sikhboi/screen/SocialScreen.dart';
import 'package:sikhboi/utils/assets_path.dart';

import '../utils/colors.dart';

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
                  icon: Image.asset(
                    AssetsPath.home,
                    width: 38,
                    height: 38,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsPath.course,
                    width: 38,
                    height: 38,
                  ),
                  label: 'Course',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsPath.translate,
                    width: 38,
                    height: 38,
                  ),
                  label: 'Translate',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsPath.social,
                    width: 38,
                    height: 38,
                  ),
                  label: 'Social',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsPath.freelance,
                    width: 38,
                    height: 38,
                  ),
                  label: 'Freelance',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    AssetsPath.ecom,
                    width: 38,
                    height: 38,
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
              LearnChat(),
              SocialScreen(),
              Freelance(),
              Ecom()
            ],
          ),
    );
  }
}
