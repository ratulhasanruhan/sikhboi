import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:sikhboi/screen/Home.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../utils/Checker.dart';
import '../utils/colors.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController refferController = TextEditingController();
  TextEditingController passCOntroller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastDonated = TextEditingController();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();


  FirebaseFirestore database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  var box = Hive.box('user');

  var area;
  var subArea;
  var organization;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sikhboi',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: color2dark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),

                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: TextStyle(
                        fontSize: 18,
                        color: blackColor,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: offWhite,
                          filled: true,
                          hintText: 'নাম',
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: BorderSide.none
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 8, top: 5, bottom: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FeatherIcons.user, color: primaryColor,),
                                  VerticalDivider(color: darkWhite,thickness:1),
                                ],
                              ),
                            ),
                          )
                      ),
                      validator: (val){
                        if(val!.isEmpty){
                          return 'আপনার নাম লিখুন';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
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
                              borderSide: BorderSide.none),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 8, top: 5, bottom: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FeatherIcons.smartphone,
                                    color: primaryColor,
                                  ),
                                  VerticalDivider(
                                      color: darkWhite, thickness: 1),
                                ],
                              ),
                            ),
                          )),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "আপনার মোবাইল নম্বর লিখুন";
                        }
                        if (val.length < 11 || !val.startsWith('01')) {
                          return "মোবাইল নম্বরটি সঠিক নয়";
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: refferController,
                      style: TextStyle(
                        fontSize: 17,
                        color: blackColor,
                      ),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "আপনার রেফারেল কোড লিখুন";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          fillColor: offWhite,
                          filled: true,
                          hintText: 'রেফারেল কোড',
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 8, top: 5, bottom: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FeatherIcons.users,
                                    color: primaryColor,
                                  ),
                                  VerticalDivider(
                                      color: darkWhite, thickness: 1),
                                ],
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10.h,
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
                              borderSide: BorderSide.none),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 8, top: 5, bottom: 5),
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FeatherIcons.lock,
                                    color: primaryColor,
                                  ),
                                  VerticalDivider(
                                      color: darkWhite, thickness: 1),
                                ],
                              ),
                            ),
                          )),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "আপনার পাসওয়ার্ড লিখুন";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    RoundedLoadingButton(
                      elevation: 0,
                      successColor: primaryColor,
                      child: Text(
                        'নিবন্ধন',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      color: primaryColor,
                      width: ScreenUtil().screenWidth,
                      controller: _btnController,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          String myCode = phoneController.text.substring(5,11);

                            //TODO: send data to server
                            bool userExists = await checkIfDocExists(phoneController.text);

                            List referUsers = [];

                          await database.collection('users').where('mycode', isEqualTo: refferController.text.trim()).get().then((value) async{
                            value.docs.forEach((element) {
                              referUsers.add(element.data()['phone']);
                            });
                          });

                            if (userExists) {
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(message: "আপনার মোবাইল নম্বর ইতিমধ্যে নিবন্ধিত রয়েছে।\nলগইন করুন "),
                              );
                              _btnController.error();
                              Future.delayed(const Duration(seconds: 1), () {
                                _btnController.reset();
                              });
                            }
                            else if(referUsers.isEmpty){
                              showTopSnackBar(
                                context,
                                const CustomSnackBar.error(message: "আপনার রেফারেল কোডটি সঠিক নয়।"),
                              );
                              _btnController.error();
                              Future.delayed(const Duration(seconds: 1), () {
                                _btnController.reset();
                              });
                            }
                            else {

                              await database.collection('users').doc(referUsers[0]).update({
                                'point' : FieldValue.increment(1),
                              });

                              await database.collection('users').doc(phoneController.text).set(
                                  {
                                    "name": nameController.text,
                                    "phone": phoneController.text,
                                    "password": passCOntroller.text,
                                    "point": 0,
                                    "image": '',
                                    "upgraded": false,
                                    "code" : refferController.text ?? '',
                                    "mycode" : myCode,
                                  }
                              ).then((value) async{

                                  await box.put('phone', phoneController.text.trim()).then((value) {

                                    _btnController.success();
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                  });


                              });

                            }

                        } else {
                          _btnController.error();
                          Future.delayed(const Duration(seconds: 1), () {
                            _btnController.reset();
                          });
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h, top: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'অ্যাকাউন্ট আছে? ',
                        style: TextStyle(color: wTextColor, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'লগইন করুন',
                          style: TextStyle(color: primaryColor, fontSize: 16),
                        ),
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