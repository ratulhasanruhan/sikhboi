import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';
import 'package:sikhboi/utils/colors.dart';

class SendOffer extends StatefulWidget {
  dynamic user;
  SendOffer({required this.user, super.key});

  @override
  State<SendOffer> createState() => _SendOfferState();
}

class _SendOfferState extends State<SendOffer> {
  final key = GlobalKey<FormState>();
  var type = Hive.box('user').get('type');
  var user = Hive.box('user').get('phone');

  final database = FirebaseFirestore.instance.collection('offer_requests');

  TextEditingController amount = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color2dark,
        title: Text(
            type == 'seller' ? 'Send Offer' : 'Offer Request',
            style: TextStyle(
              color: Colors.white,
            ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: ()async{
            // send offer
            showModalBottomSheet(context: context, builder: (context) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Form(
                    key: key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text(
                                'Enter your amount',
                                style: TextStyle(
                                  color: color2dark,
                                  fontWeight: FontWeight.bold,
                                ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            prefixIcon: Icon(Icons.attach_money),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2dark,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2dark,
                              ),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter amount';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: color2dark,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: message,
                          maxLines: 3,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter message';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text(
                              'Enter your message',
                              style: TextStyle(
                                color: color2dark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2dark,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: color2dark,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        InkWell(
                          onTap: ()async{
                            if(key.currentState!.validate()){
                              await database.add({
                                'amount': amount.text,
                                'message': message.text,
                                'sender': user,
                                'receiver': widget.user['phone'],
                                'time': Timestamp.now(),
                                'status': 'pending',
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: color2dark,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: color2dark,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Send Offer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FirestoreListView(
          query: type == 'seller'
              ? database.where('sender', isEqualTo: user).where('receiver', isEqualTo: widget.user['phone'])
              : database.where('receiver', isEqualTo: user).where('sender', isEqualTo: widget.user['phone']),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          itemBuilder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color2dark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '৳ ${snapshot['amount']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${snapshot['message']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(snapshot['time'].toDate()),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: snapshot['status'] == 'pending' ? Colors.orange : snapshot['status'] == 'accepted' ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          snapshot['status'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  type == 'buyer'
                      ? Divider(
                    color: Colors.white,
                    thickness: .5,
                  )
                      : SizedBox(),

                  type == 'buyer'
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: ()async{
                          await database.doc(snapshot.id).update({
                            'status': 'rejected',
                          }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Offer Rejected'),
                          )));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Reject',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: ()async{
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text('Accept Offer'),
                              content: Text('অফারটি একসেপ্ট করার জন্য আপনাকে অবশ্যই পেমেন্ট করতে হবে।  পেমেন্ট ভেরিফাই করার পরে অফার একসেপ্ট হয়ে যাবে। আপনি কি অফারটি একসেপ্ট করতে চান?'),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: ()async{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(amount: int.parse(snapshot['amount'].toString()), subscription: false, reason: 'offer_request')));
                                  },
                                  child: Text('Accept'),
                                ),
                              ],
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            );
          },
      ),
    );
  }
}
