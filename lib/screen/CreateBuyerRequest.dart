import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:sikhboi/utils/colors.dart';

class CreateBuyerRequest extends StatefulWidget {
  const CreateBuyerRequest({super.key});

  @override
  State<CreateBuyerRequest> createState() => _CreateBuyerRequestState();
}

class _CreateBuyerRequestState extends State<CreateBuyerRequest> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController deliveryController = TextEditingController();
  TextEditingController revisionController = TextEditingController();
  String url = '';

  bool isLoading = false;

  ImagePicker sampleImage = ImagePicker();

  XFile? sampleImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Work Post',
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
                  'কি ধরণের কাজ চান',
                  titleController,
                ),
                const SizedBox(height: 12),

                // Description Input
                customTextField(
                    'কাজের ধরণ বিস্তারিত বুঝিয়ে লিখুন',
                    descriptionController,
                    maxLines: 4),
                const SizedBox(height: 12),

                // Pricing
                customTextField(
                    'এই কাজের জন্য কত টাকা দিতে চান?',
                    priceController,
                    keyboardType: TextInputType.number
                ),
                const SizedBox(height: 12),

                // Totals and Revision
                Row(
                  children: [
                    Expanded(child: customTextField(
                      'কতদিনে ডেলিভারি চান?',
                      deliveryController,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: customTextField(
                      'কতগুলো রিভিশন চান?',
                      revisionController,
                    )),
                  ],
                ),
                const SizedBox(height: 24),

                // Image Upload Section
                const Text(
                  'কি ধরনের কাজ চাচ্ছেন তা পরিপূর্ণভাবে বুঝাতে ছবি অথবা যে কোন ফাইলের লিংক দিন।',
                  textAlign: TextAlign.center,
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
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('লিংক দিন'),
                              content: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    url = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'লিংক দিন',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('বাতিল করুন'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('ঠিক আছে'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                            Icon(Icons.add_link_outlined, color: Colors.green, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'Link Here',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                    sampleImageFile != null
                        ? Image.file(
                      File(sampleImageFile!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : uploadPhotoBox(
                          () {
                        sampleImage.pickImage(source: ImageSource.gallery, imageQuality: 40).then((value) {
                          setState(() {
                            sampleImageFile = value;
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
                        if(sampleImageFile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('ইমেজ দিতে হবে'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        else{
                          setState(() {
                            isLoading = true;
                          });
                          FirebaseFirestore.instance.collection('buyer_request').add({
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'url': url,
                            'price': priceController.text,
                            'delivery': deliveryController.text,
                            'revision': revisionController.text,
                            'time' : Timestamp.now(),
                            'user': Hive.box('user').get('phone'),
                          }).then((value) {
                            FirebaseStorage.instance.ref('buyer_request/${value.id}/sample.jpg').putFile(File(sampleImageFile!.path));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ওয়ার্ক পোস্ট সাবমিট হয়েছে'),
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
