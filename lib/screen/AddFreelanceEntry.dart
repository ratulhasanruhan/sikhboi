import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:sikhboi/utils/colors.dart';

class AddFreelanceEntry extends StatefulWidget {
  final String id;
  AddFreelanceEntry({Key? key, required this.id}) : super(key: key);

  @override
  State<AddFreelanceEntry> createState() => _AddFreelanceEntryState();
}

class _AddFreelanceEntryState extends State<AddFreelanceEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final RoundedLoadingButtonController controller = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কাজ জমা দিন'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text('কাজের বিবরণ'),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'কাজের বিবরণ লিখুন',
              ),
              maxLines: 7,
              minLines: 1,
              validator: (value){
                if(value!.isEmpty){
                  return 'কাজের বিবরণ লিখুন';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text('কাজের ছবি'),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                if (pickedFile != null) {
                  setState(() {
                    image = pickedFile;
                  });
                } else {
                  print('No image selected.');
                }
              },
              child: image == null
                  ?     Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                    left: BorderSide(width: 1.0, color: Colors.grey),
                    right: BorderSide(width: 1.0, color: Colors.grey),
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: const Center(
                  child: Text('ছবি যুক্ত করুন'),
                ),
              )
                  : Image.file(
                File(image!.path),
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 12),

            const Text('ফ্রীলান্সার কোড'),
            const SizedBox(height: 4),
            TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'আপনার ফ্রীলান্সার কোড লিখুন',
              ),
              keyboardType: TextInputType.number,
              validator: (value){
                if(value!.isEmpty){
                  return 'আপনার ফ্রীলান্সার কোড লিখুন';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            RoundedLoadingButton(
                controller: controller,
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    await FirebaseFirestore.instance.collection('admin').doc('freelance').get().then((value) async{
                      List<dynamic> code = value['code'];

                      if(code.contains(codeController.text)) {
                        await FirebaseStorage.instance.ref().child('freelance/${DateTime.now().millisecondsSinceEpoch}').putFile(File(image!.path)).then((p0) {
                          p0.ref.getDownloadURL().then((value) async{
                            await FirebaseFirestore.instance.collection('freelance').doc(widget.id).collection('entries').add({
                              'description': _descriptionController.text,
                              'image': value,
                              'time': Timestamp.now(),
                              'user': Hive.box('user').get('phone'),
                              'rating' : 0,
                              'winner' : false,
                            }).then((value) {
                              controller.success();
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'আপনার কাজটি সফলভাবে জমা দেয়া হয়েছে।',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8),
                                          MaterialButton(
                                            onPressed: (){
                                              int count = 0;
                                              Navigator.of(context).popUntil((_) => count++ >= 2);
                                            },
                                            child: Text(
                                              'ওকে',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            color: pinkish,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              );
                            }).catchError((e) {
                              controller.error();
                            });
                          });
                        });
                      }
                      else{
                        controller.error();
                        showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Lottie.asset('assets/error.json', height: 150, width: 150),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'আপনার ফ্রীলান্সার কোডটি সঠিক নয়।',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    MaterialButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        Future.delayed(Duration(seconds: 1), (){
                                          controller.reset();
                                        });
                                      },
                                      child: Text(
                                        'ওকে',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      color: pinkish,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                        );
                      }

                    });
                    
                  }

                },
                color: primaryColor,
                child: Text('জমা দিন', style: TextStyle(color: Colors.white),)
            ),
          ],
        ),
      ),
    );
  }
}
