import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sikhboi/main.dart';
import 'package:sikhboi/model/UserModel.dart';
import 'package:sikhboi/screen/Login.dart';
import 'package:sikhboi/screen/WithdrawPoints.dart';
import 'package:sikhboi/widgets/upgradeDialog.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../utils/colors.dart';
import 'ChangePassword.dart';
import 'MyPosts.dart';
import 'Notifications.dart';
import 'PremiumPlan.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var box = Hive.box('user');

  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Profile',
            style: TextStyle(
              color: color2dark,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            )
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
            },
            icon: const Icon(FeatherIcons.bell),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(box.get('phone')).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            var data = UserModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

            return ListView(
              padding: EdgeInsets.all(12.r),
              physics: ClampingScrollPhysics(),
              children: [
                Center(
                  child:  WidgetCircularAnimator(
                    innerColor: primaryColor,
                    outerColor: primaryColor,
                    size: 125.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            height: 85.r,
                            width: 85.r,
                            padding: EdgeInsets.all(3.5.r),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                key: Key('profile_image'),
                                imageUrl: data.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Image.asset(
                                    'assets/avatar.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    'assets/avatar.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            )
                        ),
                        IconButton(
                          onPressed: () async{
                            picker.pickImage(source: ImageSource.gallery, imageQuality: 40).then((value) async{
                              if(value != null){
                                OverlayLoadingProgress.start(context);
                                await FirebaseStorage.instance.ref('avatar/${box.get('phone')}').putFile(File(value.path)).then((value) async{
                                  await value.ref.getDownloadURL().then((value) async{
                                    await FirebaseFirestore.instance.collection('users').doc(box.get('phone')).update({
                                      'image': value,
                                    }).then((value) {
                                      OverlayLoadingProgress.stop();

                                      setState(() {

                                      });
                                    });
                                  });
                                });
                              }
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 25.r,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 27,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF272A2F),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{

                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      Icons.currency_bitcoin_rounded,
                      color: primaryColor,
                      size: 23,
                    ),
                    title: Text(
                      'উপার্জন',
                      style: TextStyle(
                          color: Color(0xFF7c7c7c),
                          fontSize: 16,
                      ),
                    ),
                    trailing: Text(
                      data.point.toString()+'.00' + ' টাকা',
                      style: GoogleFonts.roboto(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      if(data.point >= 1000){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawPoints(points: data.point,)));
                      } /*else if(!data.upgraded){
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Lottie.asset('assets/upgrade.json', height: 150.h, width: 150.w),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'উপার্জন করতে হলে আপনার একাউন্টটি প্রিমিয়াম করতে হবে। ',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8.h),
                                    MaterialButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlan()));
                                      },
                                      child: Text(
                                        'প্রিমিয়াম করুন',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: pinkish,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                        );
                      }*/

                      else{
                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message: 'টাকা উত্তোলনের জন্য আপনার সর্বনিম্ন ১০০০ টাকা হতে হবে',
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'টাকা উত্তোলন',
                      style: TextStyle(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      showDialog(
                          context: context,
                          builder: (context){
                            TextEditingController _name = TextEditingController(text: data.name);
                            final _formKey = GlobalKey<FormState>();

                            return Form(
                              key: _formKey,
                              child: AlertDialog(
                                title: Text('Update Profie'),
                                content: TextFormField(
                                  controller: _name,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your name',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')
                                  ),
                                  TextButton(
                                    onPressed: () async{
                                      if(_formKey.currentState!.validate()){
                                        await FirebaseFirestore.instance.collection('users').doc(box.get('phone')).update({
                                          'name': _name.text,
                                        });
                                        Navigator.pop(context);
                                        showTopSnackBar(
                                          context,
                                          CustomSnackBar.success(
                                              message: "Profile updated successfully",
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    child: Text('Update')
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      FeatherIcons.edit3,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'Update Profile',
                      style: GoogleFonts.roboto(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      Icons.password,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'Change Password',
                      style: GoogleFonts.roboto(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyPosts()));
                      },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      FeatherIcons.feather,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'My Posts',
                      style: GoogleFonts.roboto(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      await FirebaseFirestore.instance.collection('users').doc(box.get('phone')).get().then((value) {
                        if(value.data()!['mycode'] == null){
                          FirebaseFirestore.instance.collection('users').doc(box.get('phone')).update({
                            'mycode': box.get('phone').toString().substring(5,11),
                          });
                        }
                        else{
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text('Referral Code'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Your phone is your referral code.Your referral code is:',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Text(
                                        value.data()!['mycode'],
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text('Close')
                                    ),
                                    TextButton(
                                        onPressed: (){
                                          Share.share('Hey! I am using this app called "Sikhboi". Use my referral code ${box.get('phone')}. Download the app from https://play.google.com/store/apps/details?id=com.rhrsoft.sikhboi');
                                        },
                                        child: Text('Share')
                                    ),
                                  ],
                                );
                              }
                          );
                        }
                      });

                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      FeatherIcons.users,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'Referral Code',
                      style: GoogleFonts.roboto(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    onTap: () async{
                      showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text('Logout'),
                              content: Text('Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel')
                                ),
                                TextButton(
                                  onPressed: () async{
                                    await box.clear();
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                                  },
                                  child: Text('Logout')
                                ),
                              ],
                            );
                          }
                      );
                    },
                    minLeadingWidth: 5,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(
                      Icons.logout,
                      color: primaryColor,
                      size: 22,
                    ),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.roboto(
                        color: Color(0xFF7c7c7c),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
