import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sikhboi/screen/FreeCourseOutline.dart';
import 'package:sikhboi/screen/LearningType.dart';
import 'package:sikhboi/utils/colors.dart';
import 'VideoList.dart';

class Learning extends StatefulWidget {
  const Learning({Key? key}) : super(key: key);

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      body: FirestoreListView(
        query: FirebaseFirestore.instance.collection('course'),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric( vertical: 5),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCourseOutline(catId: snapshot.id)));
              },
              radius: 10,
              child: Container(
                height: 175,
                decoration: BoxDecoration(
                  color: Color(0xFF272264),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(snapshot['icon']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
