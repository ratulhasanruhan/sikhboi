import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:sikhboi/utils/colors.dart';

class FreelanceBuyerSignup extends StatefulWidget {
  const FreelanceBuyerSignup({super.key});

  @override
  State<FreelanceBuyerSignup> createState() => _FreelanceBuyerSignupState();
}

class _FreelanceBuyerSignupState extends State<FreelanceBuyerSignup> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyDescriptionController = TextEditingController();
  TextEditingController companyTypeController = TextEditingController();
  TextEditingController workTypeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController postOfficeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  ImagePicker profileImagePicker = ImagePicker();
  ImagePicker companyImagePicker = ImagePicker();
  ImagePicker idImagePicker = ImagePicker();

  XFile? profileImage;
  XFile? companyImage;
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
          'Create Your Buyer Account',
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
                      await profileImagePicker.pickImage(source: ImageSource.gallery).then((value) {
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
                  buildTextField('আপনার প্রতিষ্ঠানের নাম', companyNameController),
                  buildTextField('আপনার প্রতিষ্ঠানের সম্পর্কে কিছু লিখুন', companyDescriptionController,
                      maxLines: 4),
                  buildTextField('আপনার প্রতিষ্ঠান কি অফলাইন/অনলাইন?', companyTypeController),
                  buildTextField('আপনি কি ধরণের কাজ করতে চান?', workTypeController),
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
                  TextButton.icon(
                    onPressed: () async{
                      await companyImagePicker.pickImage(source: ImageSource.gallery).then((value) {
                        if (value != null) {
                          setState(() {
                            companyImage = value;
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
                    'আপনার প্রতিষ্ঠানের অন্তত ৩ টি ছবি দিন, যা আপনার প্রোফাইলে যুক্ত হবে।',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () async {
                      await idImagePicker.pickImage(source: ImageSource.gallery).then((value) {
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
                          isLoading = true;
                          // Save to Firebase
                          firestore.collection('freelance_buyer').doc(user).set({
                            'name': nameController.text,
                            'company_name': companyNameController.text,
                            'company_description': companyDescriptionController
                                .text,
                            'company_type': companyTypeController.text,
                            'work_type': workTypeController.text,
                            'dob': dobController.text,
                            'address': addressController.text,
                            'district': districtController.text,
                            'post_office': postOfficeController.text,
                            'email': emailController.text,
                          }).then((value) async {
                            // Upload Images
                            Reference profileRef = storage.ref().child(
                                'freelance_buyer/${user}/profile.jpg');
                            await profileRef.putFile(File(profileImage!.path));

                            Reference companyRef = storage.ref().child(
                                'freelance_buyer/${user}/company.jpg');
                            await companyRef.putFile(File(companyImage!.path));

                            Reference idRef = storage.ref().child(
                                'freelance_buyer/${user}/id.jpg');
                            await idRef.putFile(File(idImage!.path));

                            // Save to Hive
                            Hive.box('user').put('type', 'buyer');

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
