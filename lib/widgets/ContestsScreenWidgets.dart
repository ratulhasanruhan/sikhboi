import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../screen/AddFreelance.dart';
import '../screen/ContestsDetails.dart';
import '../utils/colors.dart';
import '../utils/time_difference.dart';

Widget contestScreen (BuildContext context) {
  return Stack(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: FirestoreListView(
          query: FirebaseFirestore.instance
              .collection('freelance')
              .where('approved', isEqualTo: true)
              .orderBy('time', descending: true),
          padding: const EdgeInsets.all(8.0),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, snapshot) {
            return Card(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContestsDetails(
                              data: snapshot, id: snapshot.id)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hive.box('user').get('phone') == '' ||
                        Hive.box('user').get('phone') == null ||
                        snapshot['user'] != Hive.box('user').get('phone')
                        ? Container()
                        : Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'আপনার করা পোস্ট',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              child: Icon(
                                Icons.delete,
                                color: Colors.grey,
                              ),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'আপনি কি নিশ্চিত?'),
                                        content: const Text(
                                            'আপনি কি এই পোস্টটি মুছতে চান?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('না'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection('freelance')
                                                  .doc(snapshot.id)
                                                  .delete()
                                                  .then((value) {
                                                ScaffoldMessenger.of(
                                                    context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'পোস্ট মুছে ফেলা হয়েছে'),
                                                  ),
                                                );
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text('হ্যাঁ'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              snapshot['category'],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            snapshot['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                calculateTimeDifference(
                                    startDate:
                                    snapshot['time'].toDate(),
                                    endDate: DateTime.now())
                                    .replaceAll('-', '') +
                                    ' আগে',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                snapshot['price'].toString() + '৳',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: FloatingActionButton(
          onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddFreelance()));
          },
          child: const Icon(Icons.add_task_rounded),
        ),
      )
    ],
  );
}