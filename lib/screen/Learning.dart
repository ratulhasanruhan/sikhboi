import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:sikhboi/screen/LearningType.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text(
            'Free Learning',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LearningType()));
            },
            icon: const Icon(Icons.arrow_back),
          )
      ),
      body: FirestoreListView(
        query: FirebaseFirestore.instance.collection('course'),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric( vertical: 5),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(catId: snapshot.id)));
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
