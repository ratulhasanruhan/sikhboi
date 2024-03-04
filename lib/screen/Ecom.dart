import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sikhboi/screen/CategoryProducts.dart';
import 'package:sikhboi/screen/ProductSearch.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'ProductDetails.dart';

class Ecom extends StatefulWidget {
  const Ecom({Key? key}) : super(key: key);

  @override
  State<Ecom> createState() => _EcomState();
}

class _EcomState extends State<Ecom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r),
                          ),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('admin').doc('home').snapshots(),
                            builder: (context,AsyncSnapshot snapshot) {
                              if(snapshot.hasData){
                                return CarouselSlider.builder(
                                    itemCount: snapshot.data['ecom_slider'].length,
                                    itemBuilder: (context, index, page){
                                      return Image.network(
                                        snapshot.data['ecom_slider'][index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 220.h,
                                      viewportFraction: 1,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 2),
                                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.easeInOut,
                                      enlargeCenterPage: false,
                                    )
                                );
                              }
                              return Text('Loading...');
                            }
                          ),
                        ),
                        SizedBox(
                          height: 45.h,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(18.h),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.r),
                        ),
                        elevation: 5,
                        shadowColor: waterColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18.r),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductSearch(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(11.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.r),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  FeatherIcons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'কী ধরণের পণ্য খুঁজছেন?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('category').snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return SizedBox(
                    height: 90.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.docs.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProducts(
                                      name: snapshot.data.docs[index]['name'],
                                      video: snapshot.data.docs[index]['video'],
                                    )));
                                  },
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    height: 50.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: listBack[Random().nextInt(listBack.length)],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8.h),
                                      child: Image.network(
                                        snapshot.data.docs[index]['icon'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  snapshot.data.docs[index]['name'],
                                  maxLines: 2,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                        );
                      },
                    ),
                  );
                }
                return SizedBox(
                  height: 90.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                      primary: false,
                      itemCount: 8,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(left: 20.w),
                          child: Column(
                            children: [
                              Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: listBack[Random().nextInt(listBack.length)],
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.h),
                                  child: Image.network(
                                    'https://cdn-icons-png.flaticon.com/512/3300/3300371.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Fashion',
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        );
                      },
                  ),
                );
              }
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData){
                  return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length ,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.82,
                      ),
                      itemBuilder: (context, index){
                        return Card(
                          elevation: 0.7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          color: Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetails(data: snapshot.data.docs[index].data(), id: snapshot.data.docs[index].id,)));
                            },
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.network(
                                          snapshot.data.docs[index]['image'][0],
                                          fit: BoxFit.cover,
                                          height: 100.h,
                                          width: double.infinity,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['name'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '৳'+' ${snapshot.data.docs[index]['price']}',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        '৳'+' ${snapshot.data.docs[index]['price']*1.2}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
                return Text('Loading...');
              }
            )
          ],
        ),
      ),
    );
  }
}
