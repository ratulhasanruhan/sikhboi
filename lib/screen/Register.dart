import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:sikhboi/screen/Home.dart';
import 'package:sikhboi/utils/assets_path.dart';
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
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();


  FirebaseFirestore database = FirebaseFirestore.instance;
  var box = Hive.box('user');


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backGreen,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 0, right: 20, left: 20),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 60,
                        ),

                        Image.asset(
                          'assets/logo_stamp.png',
                          height: 120,
                        ),
                        Text(
                          'Register Your Account',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: color2dark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                                  borderRadius: BorderRadius.circular(6),
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
                          height: 10,
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
                        SizedBox(
                          height: 10,
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
                          height: 10,
                        ),
                        TextFormField(
                          controller: refferController,
                          style: TextStyle(
                            fontSize: 17,
                            color: blackColor,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                              fillColor: offWhite,
                              filled: true,
                              hintText: 'রেফারেল কোড (অপশনাল)',
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
                          height: 40,
                        ),
                        RoundedLoadingButton(
                          elevation: 0,
                          successColor: primaryColor,
                          child: Text(
                            'Let\'s Go',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          color: primaryColor,
                          width: MediaQuery.of(context).size.width * 0.5,
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
                                    Overlay.of(context),
                                    const CustomSnackBar.error(message: "আপনার মোবাইল নম্বর ইতিমধ্যে নিবন্ধিত রয়েছে।\nলগইন করুন "),
                                  );
                                  _btnController.error();
                                  Future.delayed(const Duration(seconds: 1), () {
                                    _btnController.reset();
                                  });
                                }
                                else {

                                  if(referUsers.isNotEmpty){
                                    await database.collection('users').doc(referUsers[0]).update({
                                      'point' : FieldValue.increment(50),
                                    });
                                  }

                                  await database.collection('users').doc(phoneController.text).set(
                                      {
                                        "name": nameController.text,
                                        "phone": phoneController.text,
                                        "password": passCOntroller.text,
                                        "point": refferController.text.trim() == '' ? 0 : 50,
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
                      padding: EdgeInsets.only(bottom: 12, top: 10),
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
                Positioned(
                  top: 0,
                  left: 10,
                  child: Image.asset(
                    AssetsPath.ic_bg_1,
                    height: 120,
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: -20,
                  child: Image.asset(
                    AssetsPath.ic_bg_2,
                    height: 120,
                  ),
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Image.asset(
                    AssetsPath.ic_bg_3,
                    height: 120,
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
