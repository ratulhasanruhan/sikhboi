import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';

import '../utils/colors.dart';
import 'Profile.dart';

class EnrollPremium extends StatefulWidget {
  final int amount;
  final int points;
  final String catId;

  const EnrollPremium({super.key, required this.amount, required this.points, required this.catId});

  @override
  State<EnrollPremium> createState() => _EnrollPremiumState();
}

class _EnrollPremiumState extends State<EnrollPremium> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int noticeLength = 0;
  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        backgroundColor: backGreen,
        title: Text(
          'Payment',
          style: TextStyle(
            color: color2dark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            child: StreamBuilder(
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
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  'প্রিমিয়াম কোর্সটি আপনি কোন মাধ্যমে কিনতে চান?\nআপনার জমানো পয়েন্ট কিংবা টাকা দিয়ে কিনতে পারেন!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color2dark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await firestore.collection('users').doc(box.get('phone')).get().then((value) {
                        if(value.data()?['point'] >= widget.amount){
                          firestore.collection('user').doc(box.get('phone')).update({
                            'point': value.data()?['point'] - widget.amount,
                          }).then((value) {
                            firestore.collection('paid_course').doc(widget.catId).collection('enrolled').doc(box.get('phone')).set({}).then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('কোর্সটি সফলভাবে কিনা হয়েছে!'),
                                duration: Duration(seconds: 3),
                              ));
                            });
                          });
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('আপনার পয়েন্ট পর্যাপ্ত নেই!'),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color2,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'পয়েন্ট দিয়ে কিনুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
                          amount: widget.amount,
                          subscription: true,
                          reason: 'course',
                      )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color2dark,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'টাকা দিয়ে কিনুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
