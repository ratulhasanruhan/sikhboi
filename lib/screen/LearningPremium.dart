import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/PremiumVideoList.dart';
import 'package:sikhboi/widgets/loginPermission.dart';
import 'LearningType.dart';

class LearningPremium extends StatefulWidget {
  const LearningPremium({Key? key}) : super(key: key);

  @override
  State<LearningPremium> createState() => _LearningPremiumState();
}

class _LearningPremiumState extends State<LearningPremium> {

  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirestoreListView(
        query: FirebaseFirestore.instance.collection('paid_course'),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric( vertical: 5),
            child: InkWell(
              onTap: (){
                if(box.get('phone') == '' || box.get('phone') == null){
                  loginPermissionDialog(context);
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumVideoList(catId: snapshot.id)));
                }
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
