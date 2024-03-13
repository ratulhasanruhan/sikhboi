import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/colors.dart';

class WithdrawPoints extends StatefulWidget {
  const WithdrawPoints({required this.points, Key? key}) : super(key: key);
  final int points;

  @override
  State<WithdrawPoints> createState() => _WithdrawPointsState();
}

class _WithdrawPointsState extends State<WithdrawPoints> {
  final _formKey = GlobalKey<FormState>();
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  FirebaseFirestore database = FirebaseFirestore.instance;
  var box = Hive.box('user');
  int points = 0;
  TextEditingController pointsCont = TextEditingController();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Withdraw Points',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'You have ${widget.points} taka',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: blackColor,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16),
            TextFormField(
              controller: pointsCont,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: blackColor,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                  fillColor: offWhite,
                  filled: true,
                  hintText: 'Amount to withdraw',
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 8, top: 5, bottom: 5),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.currency_bitcoin_rounded, color: primaryColor,),
                          VerticalDivider(color: darkWhite,thickness:1),
                        ],
                      ),
                    ),
                  )
              ),
              validator: (val){
                if(val!.isEmpty){
                  return "Please enter amount";
                }
                return null;
              },
              onChanged: (val){
                setState(() {
                  points = int.parse(val);
                });
              },
            ),
            SizedBox(height: 10,),

            SizedBox(height: 30,),
            RoundedLoadingButton(
              color: primaryColor,
              controller: _btnController,
              onPressed: () async {
                if(points <= widget.points){

                    await database.collection('users').doc(box.get('phone')).update({
                      'point': FieldValue.increment(-points),
                    });
                    await database.collection('withdraw').add({
                      'phone': box.get('phone'),
                      'points': points,
                      'time': DateTime.now(),
                    });
                    _btnController.success();
                    showTopSnackBar(context, CustomSnackBar.success(
                      message: 'Withdraw request sent',
                      backgroundColor: Colors.green,
                    ));
                    Future.delayed(Duration(seconds: 2), (){
                      Navigator.pop(context);
                    });
                }
                else{
                  showTopSnackBar(context, CustomSnackBar.error(
                    message: 'আপনার পর্যাপ্ত টাকা নেই',
                    backgroundColor: Colors.red,
                  ));
                  _btnController.reset();
                }
              },
              child: Text('সাবমিট',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
