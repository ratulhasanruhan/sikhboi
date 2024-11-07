import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/colors.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  var image;
  ImagePicker picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();
  RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  bool isVideo = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: [
          Card(
            color: Colors.white,
            elevation: 3,
            shadowColor: waterColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () async{
                    if(isVideo) {
                      picker.pickVideo(source: ImageSource.gallery,maxDuration: Duration(seconds: 30)).then((value) {
                        setState(() {
                          image = value;
                        });
                      });
                    }else{
                      picker.pickImage(source: ImageSource.gallery, imageQuality: 50).then((value) {
                        setState(() {
                          image = value;
                        });
                      });
                    }


                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                    child: image == null

                        ? Image.asset(
                      isVideo ? 'assets/add_video.png' : 'assets/add_image.png',
                      height: 140,
                      width: double.infinity,
                    )
                        : Stack(
                      children: [

                        isVideo
                        ? Container(
                          height: 140,
                          width: double.infinity,
                          child: Center(
                              child: Text(
                                  'Selected',
                                style: TextStyle(
                                  color: blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                          ),
                        )
                        :Image.file(
                          File(image!.path),
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                image = null;
                              });
                            },
                            child: Container(
                              padding:  EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Photo',
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Switch(
                        value: isVideo,
                        onChanged: (val) async{
                          await FirebaseFirestore.instance.collection('admin').doc('function').get().then((value) {
                            if(value.data()!['video'] == true) {
                              setState(() {
                                isVideo = val;
                              });
                            }else{
                              showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message: 'Video upload is disabled by admin',
                                ),
                              );
                            }
                          });
                        },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Video',
                        style: TextStyle(
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    minLines: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RoundedLoadingButton(
            elevation: 5,
            color: primaryColor,
            controller: _btnController,
            onPressed: (){
                if (image == null) {
                  _btnController.error();
                  _btnController.reset();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select an image'),
                    ),
                  );
                }
                else {
                  OverlayLoadingProgress.start(
                      context,
                    barrierDismissible: false,
                    barrierColor: Colors.black.withOpacity(0.5),
                    widget: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Lottie.asset('assets/uploading.json'),
                      ),
                    ),
                  );

                  FirebaseStorage.instance.ref('posts/${DateTime.now().millisecondsSinceEpoch}').putFile(File(image.path)).then((p0) {

                   /* FirebaseFirestore.instance.collection('users').doc(Hive.box('user').get('phone')).update(
                        {
                          'point': FieldValue.increment(1),
                        }
                    );*/


                      p0.ref.getDownloadURL().then((value) {
                        FirebaseFirestore.instance.collection('posts').add(
                            {
                              'description': descriptionController.text,
                              'image': value,
                              'time': Timestamp.now(),
                              'user': Hive.box('user').get('phone'),
                              'isVideo': isVideo,
                            }
                        ).then((value) async {
                          OverlayLoadingProgress.stop();

                          _btnController.success();
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                message: "Successfully posted",
                                backgroundColor: Colors.green,
                              ),
                            );
                          });

                        });
                      });
                    });


              }

            },
            child: Text(
              'POST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
