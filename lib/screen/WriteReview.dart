import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class WriteReview extends StatefulWidget {
  final String product;
  const WriteReview({Key? key, required this.product}) : super(key: key);

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  var user = Hive.box('user').get('phone');
  final TextEditingController reviewController = TextEditingController();
  double rating = 5;

  ImagePicker picker = ImagePicker();
  List<XFile> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'পণ্যের পর্যালোচনা',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(

            children: [
              SizedBox(height: 20,),
              Text(
                widget.product,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 20,),
              RatingBar(
                initialRating: rating,
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: Colors.amber,),
                    half: const Icon(Icons.star_half, color: Colors.amber,),
                    empty: const Icon(Icons.star_border, color: Colors.amber,),
                  ),
                  onRatingUpdate: (r) {
                    setState(() {
                      rating = r;
                    });
                  },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: reviewController,
                decoration: const InputDecoration(
                  hintText: 'আপনার পর্যালোচনা লিখুন',
                  border: OutlineInputBorder(),
                ),
                minLines: 3,
                maxLines: 5,
              ),
              SizedBox(height: 10,),

              images.isEmpty
                  ? Container(
                    height: 180.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        images = await picker.pickMultiImage(imageQuality: 30);
                        setState(() {});
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           const Icon(Icons.add_a_photo),
                          const Text('ছবি যুক্ত করুন')
                        ],
                      ),
                    ),
              )
                  : SizedBox(
                    height: 180.h,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 180.h,
                                width: 180.w,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(File(images[index].path)),
                                    fit: BoxFit.cover
                                  )
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    images.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async{
                  if(images.isNotEmpty) {
                    OverlayLoadingProgress.start(context);

                    List<String> urls = [];
                    for (var image in images) {
                      var ref = FirebaseStorage.instance.ref().child('review/${DateTime.now().millisecondsSinceEpoch}');
                      await ref.putFile(File(image.path));
                      var url = await ref.getDownloadURL();
                      urls.add(url);
                    }
                    var name = FirebaseFirestore.instance.collection('users').doc(user).get().then((value) => value.data()!['name']);
                    await FirebaseFirestore.instance.collection('products').where('name', isEqualTo: widget.product).limit(1).get().then((value) {
                      value.docs[0].reference.collection('review').add({
                        'rating': rating,
                        'review': reviewController.text ?? '',
                        'image': urls,
                        'name': name,
                        'time': Timestamp.now()
                      });
                    }).then((value) {
                      OverlayLoadingProgress.stop();
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        title: 'ধন্যবাদ',
                        text: 'আপনার পর্যালোচনা গ্রহণ করা হয়েছে',
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    });
                  }
                  else {
                    var name = FirebaseFirestore.instance.collection('users').doc(user).get().then((value) => value.data()!['name']);

                    await FirebaseFirestore.instance.collection('products').where('name', isEqualTo: widget.product).limit(1).get().then((value) {
                      value.docs[0].reference.collection('review').add({
                        'product': widget.product,
                        'rating': rating,
                        'review': reviewController.text ?? '',
                        'image': [],
                        'name': name,
                        'time': Timestamp.now()
                      });
                    }).then((value) {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        title: 'ধন্যবাদ',
                        text: 'আপনার পর্যালোচনা গ্রহণ করা হয়েছে',
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    });
                  }
                },
                child: const Text(
                  'রিভিউ দিন',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
