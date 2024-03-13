import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sikhboi/screen/PaymentScreen.dart';

class AddFreelance extends StatefulWidget {
  const AddFreelance({Key? key}) : super(key: key);

  @override
  State<AddFreelance> createState() => _AddFreelanceState();
}

class _AddFreelanceState extends State<AddFreelance> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  String? dropdownValue;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('কাজ পোস্ট করুন'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'কাজের ধরণ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'কাজের ধরণ লিখুন';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 18,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'কাজের ক্যাটেগরি',
                  ),
                items: [
                  DropdownMenuItem(
                    child: Text('লোগো ডিজাইন (৫০০ টাকা)'),
                    value: ' লোগো ডিজাইন (৫০০ টাকা)',
                  ),
                  DropdownMenuItem(
                    child: Text('ইউটিউব থাম্বেল ডিজাইন (৩০০ টাকা)'),
                    value: 'ইউটিউব থাম্বেল ডিজাইন (৩০০ টাকা)',
                  ),
                  DropdownMenuItem(
                    child: Text('ব্যানার ডিজাইন (৩০০) টাকা'),
                    value: 'ব্যানার ডিজাইন (৩০০) টাকা',
                  ),
                  DropdownMenuItem(
                    child: Text('সোস্যাল কভার ডিজাইন (৩০০) টাকা'),
                    value: 'সোস্যাল কভার ডিজাইন (৩০০) টাকা',
                  ),
                  DropdownMenuItem(
                    child: Text('ফেজবুক পোষ্ট ডিজাইন (২০০) টাকা'),
                    value: 'ফেজবুক পোষ্ট ডিজাইন (২০০) টাকা',
                  ),
                  DropdownMenuItem(
                    child: Text('পোষ্টার ডিজাইন ( ৩০০ টাকা )'),
                    value: 'পোষ্টার ডিজাইন ( ৩০০ টাকা )',
                  ),
                ],
                onChanged: (val){
                  setState(() {
                    dropdownValue = val.toString();
                  });
                },
              validator: (val){
                if(val == null){
                  return 'কাজের ক্যাটেগরি নির্বাচন করুন';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 18,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'কাজের বিবরণ',
                hintText: 'বিস্তারিত লিখুন',
              ),
              minLines: 3,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'কাজের বিবরণ লিখুন';
                }
              },
            ),
            const SizedBox(
              height: 18,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'অর্থের পরিমান',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'অর্থের পরিমান লিখুন';
                }
                else if (int.parse(value) < 200) {
                  return 'অর্থের পরিমান অবশ্যই ২০০ টাকা বা তার বেশি হতে হবে';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 18,
            ),

            InkWell(
              onTap: () async {
                final pickedFile =
                await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                if (pickedFile != null) {
                  setState(() {
                    image = pickedFile;
                  });
                } else {
                  print('No image selected.');
                }
              },
              child: image == null
                  ? Container(
                height: 100,
                width: 100,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.attachment_rounded,
                  size: 50,
                ),
              )
                  : Image.file(
                File(image!.path),
                height: 100,
                width: 100,
              ),
            ),

            const SizedBox(
              height: 22,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                            amount: int.parse(_priceController.text),
                            subscription: false,
                            reason: 'freelance: ${_titleController.text}',
                            data: {
                              'title': _titleController.text,
                              'category': dropdownValue,
                              'description': _descriptionController.text,
                              'price': int.parse(_priceController.text),
                              'image': image?.path ?? '',
                              'approved' : false,
                              'time' : Timestamp.now(),
                              'user' : Hive.box('user').get('phone'),
                            },
                        ),
                      ),
                    );
                  }
                },
                child: const Text('পেমেন্ট করুন'),
              ),
            ),


    ]
    ),
      )
    );
  }
}
