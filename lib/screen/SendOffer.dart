import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';
import 'package:sikhboi/utils/assets_path.dart';
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
  TextEditingController bkash = TextEditingController();

  TextEditingController buyerSendAccount = TextEditingController();
  TextEditingController buyerTrxId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color2dark,
        title: Text(
            'Order Request',
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
            showDialog(context: context, builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 22,
                  ),
                  child: Form(
                    key: key,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            'বায়ারকে আপনার অর্ডার রিকোয়েস্ট পাঠান',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 14,),
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
                        SizedBox(height: 10),
                        TextFormField(
                          controller: bkash,
                          keyboardType: TextInputType.phone,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Please enter bkash number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text(
                              'Enter your bKash number',
                              style: TextStyle(
                                color: color2dark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Image.asset(
                                AssetsPath.bkash,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 30,
                              maxWidth: 30,
                            ),
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
                        SizedBox(height: 10,),
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
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Image.asset(
                                AssetsPath.taka,
                              ),
                            ),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 30,
                              maxWidth: 30,
                            ),
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
                        SizedBox(height: 16),
                        InkWell(
                          onTap: ()async{
                            if(key.currentState!.validate()){
                              await database.add({
                                'amount': amount.text,
                                'message': message.text,
                                'sender': user,
                                'receiver': widget.user['phone'],
                                'time': Timestamp.now(),
                                'bkash': bkash.text,
                                'status': 'pending',
                              });
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'রিকোয়েস্ট পাঠান',
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
                'Order Request',
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
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color2dark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                  SizedBox(height: 6),
                  Text(
                    '${snapshot['message']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetsPath.bkash,
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          '${snapshot['bkash']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Clipboard.setData(ClipboardData(text: snapshot['bkash']));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('bKash number copied'),
                            ));
                          },
                          child: Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          AssetsPath.taka,
                          height: 20,
                          width: 20,
                        ),
                        Text(
                          '${snapshot['amount']} টাকা',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),

                  type == 'buyer' && snapshot['status'] == 'pending'
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
                          showModalBottomSheet(
                              context: context,
                              builder: (context){
                                return Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '৳ ${snapshot['amount']}',
                                        style: TextStyle(
                                          color: color2dark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                        ),
                                      ),
                                      Divider(),
                                      Text(
                                        'Send to this account'
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'bKash: ${snapshot.data().keys == 'bkash' ? snapshot['bkash'] : 'Not Provided'}',
                                            style: TextStyle(
                                              color: color2dark,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          InkWell(
                                            onTap: (){
                                              Clipboard.setData(ClipboardData(text: snapshot['bkash']));
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text('bKash number copied'),
                                              ));
                                            },
                                            child: Icon(
                                              Icons.copy,
                                              color: color2dark,
                                              size: 18,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      TextField(
                                        controller: buyerSendAccount,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'যে একাউন্ট থেকে পাঠিয়েছেন',
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
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: buyerTrxId,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          label: Text(
                                            'ট্রানজেকশন আইডি',
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
                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap: ()async{
                                          if(buyerSendAccount.text.isNotEmpty && buyerTrxId.text.isNotEmpty){
                                            await database.doc(snapshot.id).update({
                                              'status': 'Awaiting Approval',
                                              'buyerSendAccount': buyerSendAccount.text,
                                              'buyerTrxId': buyerTrxId.text,
                                            }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text('Offer Accepted'),
                                            )));
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
                                              'Accept',
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
                                );
                              }
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Pay',
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

                  SizedBox(
                    height: 5,
                  ),
                  type == 'seller' && snapshot['status'] == 'Awaiting Approval'
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Payment Confirmation'),
                                  content: Text('আপনি কি টাকা পেয়েছেন ?'),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')
                                    ),
                                    TextButton(
                                        onPressed: ()async{
                                          await database.doc(snapshot.id).update({
                                            'status': 'accepted',
                                          }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Offer Accepted'),
                                          )));
                                          Navigator.pop(context);
                                        },
                                        child: Text('Yes')
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : SizedBox()
                ],
              ),
            );
          },
      ),
    );
  }
}
