import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/Notifications.dart';
import 'package:sikhboi/utils/time_difference.dart';
import 'package:sikhboi/widgets/loginPermission.dart';

import '../utils/colors.dart';
import 'AddFreelance.dart';
import 'FreelanceDetails.dart';

class Freelance extends StatefulWidget {
  const Freelance({Key? key}) : super(key: key);

  @override
  State<Freelance> createState() => _FreelanceState();
}

class _FreelanceState extends State<Freelance> {
  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ফ্রিল্যান্স'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                if (box.get('phone') == '' || box.get('phone') == null) {
                  loginPermissionDialog(context);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                }
              },
              icon: const Icon(FeatherIcons.bell),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (box.get('phone') == '' || box.get('phone') == null) {
              loginPermissionDialog(context);
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddFreelance()));
            }
          },
          child: const Icon(Icons.add_task_rounded),
        ),
        body: FirestoreListView(
          query: FirebaseFirestore.instance
              .collection('freelance')
              .where('approved', isEqualTo: true)
              .orderBy('time', descending: true),
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, snapshot) {
            return Card(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FreelanceDetails(
                              data: snapshot, id: snapshot.id)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    box.get('phone') == '' ||
                            box.get('phone') == null ||
                            snapshot['user'] != box.get('phone')
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
                            height: 4.h,
                          ),
                          Text(
                            snapshot['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
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
        ));
  }
}
