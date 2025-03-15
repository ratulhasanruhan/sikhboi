import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';

import '../utils/colors.dart';
import 'FreelanceMain.dart';

class FreelanceSellerSignup extends StatefulWidget {
  const FreelanceSellerSignup({super.key});

  @override
  State<FreelanceSellerSignup> createState() => _FreelanceSellerSignupState();
}

class _FreelanceSellerSignupState extends State<FreelanceSellerSignup> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController workExperienceController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController postOfficeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController educationController = TextEditingController();

  ImagePicker profileImagePicker = ImagePicker();
  ImagePicker workImagePicker = ImagePicker();
  ImagePicker idImagePicker = ImagePicker();

  XFile? profileImage;
  XFile? workImage;
  XFile? idImage;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  var user = Hive.box('user').get('phone');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Create Your Seller Account',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(
          Icons.account_circle,
          color: Colors.black87,
          size: 30,
        ),
      ),
      body: OverlayLoaderWithAppIcon(
        isLoading: isLoading,
        circularProgressColor: primaryColor,
        borderRadius: 20,
        appIcon: Image.asset('assets/logo_stamp.png'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                profileImage != null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(File(profileImage!.path)),
                )
                    :
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () async {
                    await profileImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
                      if (value != null) {
                        setState(() {
                          profileImage = value;
                        });
                      }
                    });
                  },
                  icon: const Icon(Icons.add, color: primaryColor),
                  label: const Text(
                    'Upload Photo',
                    style: TextStyle(color: primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form Fields
                buildTextField('সম্পূর্ণ নাম', nameController),
                buildTextField('আপনার সম্পর্কে কিছু লিখুন', aboutMeController,
                    maxLines: 3),
                buildTextField('আপনি কোন বিষয়ে দক্ষ?', skillController),
                buildTextField('আপনার অভিজ্ঞতা কত বছরের?', workExperienceController, keyboardType: TextInputType.number),
                buildTextField('আপনার শিক্ষাগত যোগ্যতা দিন', educationController),
                buildTextField('আপনার জন্মতারিখ',dobController, keyboardType: TextInputType.datetime),
                buildTextField('আপনার সম্পূর্ণ ঠিকানা',addressController, maxLines: 2),
                Row(
                  children: [
                    Expanded(
                      child: buildTextField('জেলা', districtController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: buildTextField('ডাকবিভাগ', postOfficeController),
                    ),
                  ],
                ),
                buildTextField('ইমেইল',emailController, keyboardType: TextInputType.emailAddress),

                workImage != null
                    ? Image.file(
                  File(workImage!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
                    : Container(),

                TextButton.icon(
                  onPressed: () async{
                    await workImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
                      if (value != null) {
                        setState(() {
                          workImage = value;
                        });
                      }
                    });

                  },
                  icon: const Icon(Icons.add, color: primaryColor),
                  label: const Text(
                    'Upload Photo',
                    style: TextStyle(color: primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'আপনার কাজের অন্তত ১০ টি ছবি দিন, যা আপনার পোর্টফোলিওতে যুক্ত হবে।',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                idImage != null
                    ? Image.file(
                  File(idImage!.path),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )
                    : Container(),
                const SizedBox(height: 6),

                TextButton.icon(
                  onPressed: () async {
                    await idImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
                      if (value != null) {
                        setState(() {
                          idImage = value;
                        });
                      }
                    });

                  },
                  icon: const Icon(Icons.add, color: primaryColor),
                  label: const Text(
                    'Upload Photo',
                    style: TextStyle(color: primaryColor),
                  ),
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'আপনার আইডি ভেরিফিকেশনের জন্য আপনার একটি আইডি কার্ড অথবা জন্মনিবন্ধন দিন',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (profileImage == null || idImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('সব তথ্য দিন'),
                          ),
                        );
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        firestore.collection('freelance_seller').doc(user).set({
                          'name': nameController.text,
                          'aboutMe': aboutMeController.text,
                          'skill': skillController.text,
                          'workExperience': workExperienceController.text,
                          'dob': dobController.text,
                          'address': addressController.text,
                          'district': districtController.text,
                          'postOffice': postOfficeController.text,
                          'email': emailController.text,
                          'education': educationController.text,
                        }).then((value) async {
                          // Upload Images
                          Reference profileRef = storage.ref().child(
                              'freelance_seller/${user}/profile.jpg');
                          await profileRef.putFile(File(profileImage!.path));

                          Reference companyRef = storage.ref().child(
                              'freelance_seller/${user}/portfolio.jpg');
                          await companyRef.putFile(File(workImage!.path));

                          Reference idRef = storage.ref().child(
                              'freelance_seller/${user}/id.jpg');
                          await idRef.putFile(File(idImage!.path));

                          // Save to Hive
                          Hive.box('user').put('type', 'seller');

                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(amount: 1750, subscription: false, reason: 'seller_signup')));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('আপনার অ্যাকাউন্ট তৈরি হয়েছে'),
                            ),
                          );
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: Size(MediaQuery.sizeOf(context).width *0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Text(
                  'ফ্রিল্যান্সার একাউন্ট খুলতে হলে অবশ্যই আপনাকে বাৎসরিক চার্জ মাত্র ১,৭৫০/- টাকা পরিশোধ করতে হবে।',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),

                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.1,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextField Widget
  Widget buildTextField(
      String hint,
      TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) {
          if (value!.isEmpty) {
            return '$hint দিন';
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text(hint),
          labelStyle: const TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Color(0xFFF0F9F4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
  }
}
