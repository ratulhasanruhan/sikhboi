import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:sikhboi/utils/colors.dart';

class CreateGig extends StatefulWidget {
  const CreateGig({super.key});

  @override
  State<CreateGig> createState() => _CreateGigState();
}

class _CreateGigState extends State<CreateGig> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController revisionController = TextEditingController();

  bool isLoading = false;


  ImagePicker image1 = ImagePicker();
  ImagePicker image2 = ImagePicker();
  ImagePicker image3 = ImagePicker();

  XFile? imageFile1;
  XFile? imageFile2;
  XFile? imageFile3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Your GiG !',
          style: TextStyle(
            color: color2dark,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(
          Icons.account_circle,
          color:color2dark,
          size: 32,
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
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                customTextField(
                    'গিগের টাইটেল দিন',
                    titleController,
                ),
                const SizedBox(height: 12),

                // Description Input
                customTextField(
                    'গিগের সঠিক ডিসক্রিপশন দিন',
                    descriptionController,
                    maxLines: 4),
                const SizedBox(height: 12),

                // Service Details
                customTextField(
                    'আপনি কি কি সার্ভিস দিবেন?',
                    serviceController,
                ),
                const SizedBox(height: 12),

                // Pricing
                customTextField(
                    'গিগের প্রাইসিং দিন',
                    priceController,
                    keyboardType: TextInputType.number
                ),
                const SizedBox(height: 12),

                // Totals and Revision
                Row(
                  children: [
                    Expanded(child: customTextField(
                        'ডেলিভারি',
                        deliveryController,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: customTextField(
                        'রিভিশন',
                        revisionController,
                    )),
                  ],
                ),
                const SizedBox(height: 24),

                // Image Upload Section
                const Text(
                  'সেরা ৩টি গিগ ইমেজ দিন',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    imageFile1 != null
                        ? Image.file(
                      File(imageFile1!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : uploadPhotoBox(
                          () {
                        image1.pickImage(source: ImageSource.gallery, imageQuality: 40).then((value) {
                          setState(() {
                            imageFile1 = value;
                          });
                        });
                      },
                    ),
                    imageFile2 != null
                        ? Image.file(
                      File(imageFile2!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : uploadPhotoBox(
                          () {
                        image2.pickImage(source: ImageSource.gallery, imageQuality: 30).then((value) {
                          setState(() {
                            imageFile2 = value;
                          });
                        });
                      },
                    ),
                    imageFile3 != null
                        ? Image.file(
                      File(imageFile3!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : uploadPhotoBox(
                          () {
                        image3.pickImage(source: ImageSource.gallery, imageQuality: 30).then((value) {
                          setState(() {
                            imageFile3 = value;
                          });
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if(imageFile1 == null || imageFile2 == null || imageFile3 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('সব ইমেজ দিতে হবে'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });
                          FirebaseFirestore.instance.collection('gigs').add({
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'service': serviceController.text,
                            'price': priceController.text,
                            'delivery': deliveryController.text,
                            'revision': revisionController.text,
                            'time' : Timestamp.now(),
                            'user': Hive.box('user').get('phone'),
                          }).then((value) {
                            FirebaseStorage.instance.ref('gigs/${value.id}/1.jpg').putFile(File(imageFile1!.path));
                            FirebaseStorage.instance.ref('gigs/${value.id}/2.jpg').putFile(File(imageFile2!.path));
                            FirebaseStorage.instance.ref('gigs/${value.id}/3.jpg').putFile(File(imageFile3!.path));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('গিগ সাবমিট হয়েছে'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'সাবমিট করুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget customTextField(
      String hint,
      TextEditingController controller,
      {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }
      ) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hint দিতে হবে';
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.black87),
        label: Text(hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Upload Photo Box
  Widget uploadPhotoBox(
      Function()? onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: Colors.green, size: 32),
            SizedBox(height: 4),
            Text(
              'Upload Photo',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
