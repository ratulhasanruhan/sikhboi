import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'EarningQuestion.dart';

class Earning extends StatefulWidget {
  const Earning({Key? key}) : super(key: key);

  @override
  State<Earning> createState() => _EarningState();
}

class _EarningState extends State<Earning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledge'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('earning').snapshots(),
          builder: (context,AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              var data = snapshot.data.docs;

              return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index){
                    return Card(
                      color: Color(0xFF04583e),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.r),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EarningQuestion(day: data[index].id),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.network(
                              data[index]['icon'],
                              height: 90.h,
                              width: 90.w,
                            ),
                            Text(
                              data[index].id,
                              style: GoogleFonts.righteous(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),


                          ],
                        ),
                      ),

                    );
                  }
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
    );
  }
}
