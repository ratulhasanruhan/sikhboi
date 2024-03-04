
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sikhboi/screen/OrderDetails.dart';
import 'package:sikhboi/utils/colors.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  final String id;
  const ProductDetails({Key? key, required this.data, required this.id}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {


  Future<bool> haveReview() async{
    return await FirebaseFirestore.instance.collection('products').doc(widget.id).collection('review').limit(1).get().then((value) => value.docs.isNotEmpty);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 3,
            shadowColor: waterColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                    itemCount: widget.data['image'].length,
                    itemBuilder: (context, index, page){
                      return InkWell(
                        onTap: (){
                          final imageProvider = Image.network(widget.data['image'][index]).image;
                          showImageViewer(context, imageProvider, onViewerDismissed: () {
                            print("dismissed");
                          });
                        },
                        child: Image.network(
                          widget.data['image'][index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
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
                ),
                SizedBox(
                  height: 6.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['name'],
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '৳'+' ${widget.data['price']}',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                '৳'+' ${widget.data['price']*1.2}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetails(
                                  price: widget.data['price'],
                                  productName: widget.data['name'],
                                  productId: widget.id,
                                )));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                  "অর্ডার দিন",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 8.h,
                ),

              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: pinkish,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'রেটিংস এবং রিভিউ',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

           FutureBuilder(
             future: haveReview(),
               builder: (context, future){
                  if(future.hasData){
                    return future.data! ?
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('products').doc(widget.id).collection('review').orderBy('time', descending: true).snapshots(),
                      builder: (context,AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          return Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                                primary: true,
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data.docs[index]['name'],
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          RatingBarIndicator(
                                            rating: snapshot.data.docs[index]['rating'].toDouble(),
                                            itemBuilder: (context, index){
                                              return Icon(
                                                Icons.star,
                                                color: Colors.redAccent,
                                              );
                                            },
                                            itemSize: 16,
                                          )
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['review'],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),


                                      snapshot.data.docs[index]['image'] != null ?

                                      SizedBox(
                                        height: 40.h,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                            primary: false,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot.data.docs[index]['image'].length,
                                            itemBuilder: (context, i){
                                              return Padding(
                                                padding: EdgeInsets.only(right: 10.w),
                                                child: InkWell(
                                                  onTap: (){
                                                    final imageProvider = Image.network(snapshot.data.docs[index]['image'][i]).image;
                                                    showImageViewer(context, imageProvider, onViewerDismissed: () {
                                                      print("dismissed");
                                                    });
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8.r),
                                                    child: Image.network(
                                                      snapshot.data.docs[index]['image'][i],
                                                      fit: BoxFit.cover,
                                                      width: 40.w,
                                                      height: 40.h,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                      )

                                     : SizedBox(
                                        height: 0,
                                      ),

                                      SizedBox(
                                        height: 10.h,
                                      )

                                    ],
                                  );
                                }
                            ),
                          );
                        }
                        return Center(
                          child: Text('Loading...'),
                        );
                      }
                    )
                        : Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 60,
                            color: Colors.grey,
                          ),
                          Text(
                            'এখনো কোন রিভিউ নেই',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
               }
           )



        ],
      ),
    );
  }
}
