import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/Checker.dart';
import '../utils/colors.dart';
import 'Home.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passCOntroller = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore database = FirebaseFirestore.instance;
  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 30,),
                    Center(child: Image.asset('assets/logo.png', height: 125,)),
                    SizedBox(
                      height: 70,
                    ),
                    TextFormField(
                      controller: phoneController,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: blackColor,
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: offWhite,
                          filled: true,
                          hintText: '018XXXXXXXX',
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
                                  Icon(FeatherIcons.smartphone, color: primaryColor,),
                                  VerticalDivider(color: darkWhite,thickness:1),
                                ],
                              ),
                            ),
                          )
                      ),
                      validator: (val){
                        if(val!.isEmpty){
                          return "আপনার মোবাইল নম্বর লিখুন";
                        }
                        if(val.length < 11 || !val.startsWith('01')){
                          return "মোবাইল নম্বরটি সঠিক নয়";
                        }
                      },
                    ),
                    TextFormField(
                      controller: passCOntroller,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: blackColor,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: offWhite,
                          filled: true,
                          hintText: '******',
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
                                  Icon(FeatherIcons.lock, color: primaryColor,),
                                  VerticalDivider(color: darkWhite,thickness:1),
                                ],
                              ),
                            ),
                          )
                      ),
                      validator: (val){
                        if(val!.isEmpty){
                          return "আপনার পাসওয়ার্ড লিখুন";
                        }
                      },
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    RoundedLoadingButton(
                      elevation: 0,
                      successColor: primaryColor,
                      child: Text('লগইন',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22
                        ),
                      ),
                      color: primaryColor,
                      width: MediaQuery.of(context).size.width,
                      controller: _btnController,
                      onPressed: () async{
                        if(_formKey.currentState!.validate()){

                          if(await checkIfDocExists(phoneController.text)) {
                            var user = await database.collection('users').doc(phoneController.text).get();

                            if(passCOntroller.text.trim() == user['password']) {

                              await box.put('phone', phoneController.text).then((value) {
                                _btnController.success();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                              });

                            }
                            else{
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(message: 'আপনার পাসওয়ার্ড সঠিক নয়')
                              );
                              _btnController.error();
                              Future.delayed(Duration(seconds: 1), (){
                                _btnController.reset();
                              });
                            }

                          }
                          else{
                            showTopSnackBar(
                                context,
                                CustomSnackBar.error(message: 'আপনার মোবাইল নম্বরটি নিবন্ধিত নয়।\nরেজিস্ট্রেশন করুন')
                            );
                            _btnController.error();
                            Future.delayed(Duration(seconds: 1), (){
                              _btnController.reset();
                            });
                          }

                        }else{
                          _btnController.error();
                          Future.delayed(const Duration(seconds: 1),(){
                            _btnController.reset();
                          });
                        }

                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('অ্যাকাউন্ট নেই? ',
                        style: TextStyle(
                            color: wTextColor,
                            fontSize: 16
                        ),),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                        },
                        child: Text('নিবন্ধন করুন',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 16
                          ),),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
