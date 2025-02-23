import 'package:flutter/material.dart';
import 'package:sikhboi/screen/FreelanceSellerSignup.dart';
import 'package:sikhboi/utils/assets_path.dart';
import 'package:sikhboi/utils/colors.dart';

import 'FreelanceBuyerSignup.dart';

class FreelanceOnboard extends StatefulWidget {
  const FreelanceOnboard({super.key});

  @override
  State<FreelanceOnboard> createState() => _FreelanceOnboardState();
}

class _FreelanceOnboardState extends State<FreelanceOnboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/freelance_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: color2.withOpacity(0.9),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                      AssetsPath.grobin_1,
                    height: 95,
                  ),
                  Text(
                    '" আপনার চাহিদামতো\n  ফ্রীল্যান্স সেবা নিন "',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontFamily: 'Ador',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 35),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: backGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FreelanceSellerSignup()));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetsPath.seller,
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Seller Account',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'আমি কাজের জন্য খুবই দক্ষ,\nআমি কাজ করতে আগ্রহী!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF54A396),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FreelanceBuyerSignup()));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetsPath.seller,
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Buyer Account',
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'আমি মানসম্মত কাজ করাতে\nআগ্রহী,ফ্রীলান্সার খুঁজছি!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF54A396),
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
