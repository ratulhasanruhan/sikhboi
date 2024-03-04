import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sikhboi/screen/Ecom.dart';
import 'package:sikhboi/screen/Freelance.dart';
import 'package:sikhboi/screen/HomeScreen.dart';
import 'package:sikhboi/screen/SocialScreen.dart';

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
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          bottomNavigationBar: FlashyTabBar(
            height: 55,
            selectedIndex: _selectedIndex,
            showElevation: true,
            onItemSelected: (index) => setState(() {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            }),
            items: [
              FlashyTabBarItem(
                icon: Icon(FeatherIcons.home),
                title: Text('হোম'),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.comment_bank_outlined),
                title: Text('সোশ্যাল'),
              ),
              FlashyTabBarItem(
                icon: Icon(Icons.screen_search_desktop_outlined),
                title: Text('ফ্রিল্যান্স'),
              ),
              FlashyTabBarItem(
                icon: Icon(FeatherIcons.shoppingCart),
                title: Text('ই-কমার্স'),
              ),
            ],
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
              SocialScreen(),
              Freelance(),
              Ecom()
            ],
          ),
        );
      },
    );
  }
}
