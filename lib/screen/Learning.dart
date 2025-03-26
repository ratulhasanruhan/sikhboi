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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soft Skills',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 230,
              child: FirestoreListView(
                query: FirebaseFirestore.instance.collection('course').where('type', isEqualTo: 'soft_skill'),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, snapshot) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 6),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCourseOutline(catId: snapshot.id)));
                        },
                        radius: 10,
                        child: Column(
                          children: [
                            Container(
                              height: 175,
                              decoration: BoxDecoration(
                                color: Color(0xFF272264),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(snapshot['icon']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                snapshot.id,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Hard Skills',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 230,
              child: FirestoreListView(
                query: FirebaseFirestore.instance.collection('course').where('type', isEqualTo: 'hard_skill'),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, snapshot) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 6),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCourseOutline(catId: snapshot.id)));
                        },
                        radius: 10,
                        child: Column(
                          children: [
                            Container(
                              height: 175,
                              decoration: BoxDecoration(
                                color: Color(0xFF272264),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(snapshot['icon']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                snapshot.id,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Language Courses',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 230,
              child: FirestoreListView(
                query: FirebaseFirestore.instance.collection('course').where('type', isEqualTo: 'language'),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, snapshot) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 6),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCourseOutline(catId: snapshot.id)));
                        },
                        radius: 10,
                        child: Column(
                          children: [
                            Container(
                              height: 175,
                              decoration: BoxDecoration(
                                color: Color(0xFF272264),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(snapshot['icon']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                snapshot.id,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
