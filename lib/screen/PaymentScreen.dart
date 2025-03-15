import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:sikhboi/screen/Home.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class PaymentScreen extends StatefulWidget {
  int amount;
  bool subscription;
  String reason;
  Map<String,dynamic>? data;
  PaymentScreen({super.key, required this.amount, required this.subscription, this.data, required this.reason});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;

  TextEditingController numberPay = TextEditingController();
  TextEditingController transId = TextEditingController();

  @override
  Widget build(BuildContext context) {

    paymentName(){
      if(_selectedIndex == 1){
        return 'bKash';
      }else if(_selectedIndex == 2){
        return 'Nagad';
      }else if(_selectedIndex == 3){
        return 'Rocket';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              widget.amount.toString()+ ' ৳',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'পেমেন্ট মেথড:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  ExpansionTile(
                      title: Text(
                        'বিকাশ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    trailing: Radio(
                      value: _selectedIndex,
                      groupValue: 1,
                      onChanged: (value) {},
                    ),
                    onExpansionChanged: (value) {
                        if(value){
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }
                    },
                    children: [
                      Text('বিকাশ পার্সোনাল নম্বর (সেন্ড মানি)'),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              bkash,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: bkash)).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Copied to Clipboard')));
                                });
                              },
                              child: Icon(Icons.copy)
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                      title: Text(
                        'নগদ',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    trailing: Radio(
                      value: _selectedIndex,
                      groupValue: 2,
                      onChanged: (value) {},
                    ),
                    onExpansionChanged: (value) {
                      if(value){
                        setState(() {
                          _selectedIndex = 2;
                        });
                      }
                    },
                    children: [
                      Text('নগদ পার্সোনাল নম্বর (সেন্ড মানি)'),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nagad,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: nagad)).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Copied to Clipboard')));
                                });
                              },
                              child: Icon(Icons.copy)
                          ),
                        ],
                      )
                    ],
                  ),
                  ExpansionTile(
                      title: Text(
                        'রকেট',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    trailing: Radio(
                      value: _selectedIndex,
                      groupValue: 3,
                      onChanged: (value) {},
                    ),
                    onExpansionChanged: (value) {
                      if(value){
                        setState(() {
                          _selectedIndex = 3;
                        });
                      }
                    },
                    children: [
                      Text('রকেট পার্সোনাল নম্বর (সেন্ড মানি)'),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rocket,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: rocket)).then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Copied to Clipboard')));
                                });
                              },
                              child: Icon(Icons.copy)
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'পেমেন্টের পরে তত্থগুলো পূরণ করুন:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: numberPay,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'যে নম্বর থেকে পে করেছেন',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: transId,
                    decoration: InputDecoration(
                      hintText: 'ট্রান্সেকশন আইডি',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ])
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    if(_selectedIndex == 0){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('পেমেন্ট পছন্দ করুন')));
                    }else{

                      if(!widget.subscription){

                        if(widget.data !=null && widget.data!['image'] != ''){
                          OverlayLoadingProgress.start(context);


                          FirebaseStorage.instance.ref().child('freelance/${DateTime.now().millisecondsSinceEpoch}').putFile(File(widget.data!['image'])).then((p0) {
                            p0.ref.getDownloadURL().then((value) async{
                              widget.data!['image'] = value;

                              await FirebaseFirestore.instance.collection('freelance').add(widget.data!);

                              await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                                'user' : Hive.box('user').get('phone'),
                                'type' : paymentName(),
                                'number' : numberPay.text,
                                'transactionId' : transId.text,
                                'time': Timestamp.now(),
                                'for' : widget.reason,
                                'amount' : widget.amount,
                              }).then((value) {
                                OverlayLoadingProgress.stop();

                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে সম্পন্ন করে দেয়া হবে। এবং আপনার পোস্ট করা কাজটি লাইভ করে দেয়া হবে।',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 8),
                                            MaterialButton(
                                              onPressed: (){
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                              },
                                              child: Text(
                                                'ওকে',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              color: pinkish,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                );
                              });
                            });
                          });


                        }
                        else{

                          if(widget.reason == 'order'){

                            if(widget.data?['promoCode'] != ''){
                              OverlayLoadingProgress.start(context);


                              await FirebaseFirestore.instance.collection('products').doc(widget.data?['productID']).get().then((value) async{

                                await FirebaseFirestore.instance.collection('users').doc(widget.data?['promoCode']).update({
                                  'point' : FieldValue.increment(value['comission']),
                                });

                                await FirebaseFirestore.instance.collection('notification').add({
                                  'title': 'Order - Pending',
                                  'description': widget.data?['product'],
                                  'time': Timestamp.now(),
                                  'user': Hive.box('user').get('phone'),
                                });

                                await FirebaseFirestore.instance.collection('orders').add(widget.data!);

                                await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                                  'user' : Hive.box('user').get('phone'),
                                  'type' : paymentName(),
                                  'number' : numberPay.text,
                                  'transactionId' : transId.text,
                                  'time': Timestamp.now(),
                                  'for' : widget.reason,
                                  'amount' : widget.amount,
                                }).then((value) {
                                  OverlayLoadingProgress.stop();

                                  showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে অর্ডার সম্পন্ন করে দেয়া হবে। এবং অতি শীঘ্রই আপনি আপনার কাঙ্ক্ষিত পণ্যটি পেয়ে যাবেন। ধন্যবাদ।',
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 8),
                                              MaterialButton(
                                                onPressed: (){

                                                  int count = 0;
                                                  Navigator.popUntil(context, (route) {
                                                    return count++ == 3;
                                                  });

                                                },
                                                child: Text(
                                                  'ওকে',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                color: pinkish,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );
                                });

                              });


                            }
                            else{
                              OverlayLoadingProgress.start(context);

                              await FirebaseFirestore.instance.collection('orders').add(widget.data!);

                              await FirebaseFirestore.instance.collection('notification').add({
                                'title': 'Order - Pending',
                                'description': widget.data?['product'],
                                'time': Timestamp.now(),
                                'user': Hive.box('user').get('phone'),
                              });

                              await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                                'user' : Hive.box('user').get('phone'),
                                'type' : paymentName(),
                                'number' : numberPay.text,
                                'transactionId' : transId.text,
                                'time': Timestamp.now(),
                                'for' : widget.reason,
                                'amount' : widget.amount,
                              }).then((value) {
                                OverlayLoadingProgress.stop();

                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে অর্ডার সম্পন্ন করে দেয়া হবে। এবং অতি শীঘ্রই আপনি আপনার কাঙ্ক্ষিত পণ্যটি পেয়ে যাবেন। ধন্যবাদ।',
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 8),
                                            MaterialButton(
                                              onPressed: (){
                                                int count = 0;
                                                Navigator.popUntil(context, (route) {
                                                  return count++ == 3;
                                                });
                                              },
                                              child: Text(
                                                'ওকে',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              color: pinkish,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                );
                              });
                            }

                          }
                          else if(widget.reason == 'live'){

                            await FirebaseFirestore.instance.collection('admin').doc('premium_live').collection('user')
                                .doc(Hive.box('user').get('phone') == null || Hive.box('user').get('phone') == '' ? numberPay.text : Hive.box('user').get('phone')).set({
                              'phone' : Hive.box('user').get('phone') == null || Hive.box('user').get('phone') == '' ? numberPay.text : Hive.box('user').get('phone'),
                              'verified' : false,
                            });

                            Hive.box('user').put('premium_live', Hive.box('user').get('phone') == null || Hive.box('user').get('phone') == '' ? numberPay.text : Hive.box('user').get('phone'));

                            await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                              'user' : Hive.box('user').get('phone') ?? "",
                              'type' : paymentName(),
                              'number' : numberPay.text,
                              'transactionId' : transId.text,
                              'time': Timestamp.now(),
                              'for' :widget.reason,
                            }).then((value) {

                              OverlayLoadingProgress.stop();

                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে সম্পন্ন করে দেয়া হবে। ধন্যবাদ!',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          MaterialButton(
                                            onPressed: (){
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                            },
                                            child: Text(
                                              'ওকে',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: pinkish,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            });
                          }
                          else{
                            await FirebaseFirestore.instance.collection('freelance').add(widget.data!);

                            await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                              'user' : Hive.box('user').get('phone'),
                              'type' : paymentName(),
                              'number' : numberPay.text,
                              'transactionId' : transId.text,
                              'time': Timestamp.now(),
                              'for' : widget.reason,
                              'amount' : widget.amount,
                            }).then((value) {
                              OverlayLoadingProgress.stop();

                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে সম্পন্ন করে দেয়া হবে। এবং আপনার পোস্ট করা কাজটি লাইভ করে দেয়া হবে।',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          MaterialButton(
                                            onPressed: (){
                                              int count = 0;
                                              Navigator.popUntil(context, (route) {
                                                return count++ == 3;
                                              });
                                            },
                                            child: Text(
                                              'ওকে',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: pinkish,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            });
                          }

                        }

                      }
                      else{
                        await FirebaseFirestore.instance.collection('payment_${widget.reason}').add({
                          'user' : Hive.box('user').get('phone'),
                          'type' : paymentName(),
                          'number' : numberPay.text,
                          'transactionId' : transId.text,
                          'time': Timestamp.now(),
                          'for' :widget.reason,
                        }).then((value) {

                          FirebaseFirestore.instance.collection('users').doc(Hive.box('user').get('phone')).get().then((value) {
                            if(value.data()!['code'] != null || value.data()!['code'] != ''){
                              FirebaseFirestore.instance.collection('users').where('mycode', isEqualTo: value.data()!['code']).get().then((value) {
                                FirebaseFirestore.instance.collection('users').doc(value.docs[0].id).update({
                                  'point' : FieldValue.increment(200),
                                });
                              });
                            }
                          });

                          OverlayLoadingProgress.stop();

                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'আপনার পেমেন্টটি সফল হয়েছে। শীঘ্রই যাচাই করে সম্পন্ন করে দেয়া হবে। ধন্যবাদ!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8),
                                      MaterialButton(
                                        onPressed: (){
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                        },
                                        child: Text(
                                          'ওকে',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: pinkish,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                          );
                        });
                      }

                    }
                  }
                },
                child: Text(
                    'পেমেন্ট করুন',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
            SizedBox(
              height: 20,
            ),
          ],



        ),
      ),
    );
  }
}
