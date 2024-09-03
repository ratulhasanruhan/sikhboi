import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:sikhboi/utils/colors.dart';

import 'AppsDownload.dart';

class FreeApps extends StatefulWidget {
  const FreeApps({super.key});

  @override
  State<FreeApps> createState() => _FreeAppsState();
}

class _FreeAppsState extends State<FreeApps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Free Apps'),
          centerTitle: true,
        ),
        body: FirestoreListView(
          padding: const EdgeInsets.all(8.0),
          query: FirebaseFirestore.instance.collection('free_apps'),
          itemBuilder: (BuildContext context, DocumentSnapshot documentSnapshot) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: primaryColor,
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AppsDownload(documentSnapshot: documentSnapshot)));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                title: Text(documentSnapshot['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Image.network(documentSnapshot['logo'],height: 35, width: 35,),
              ),
            );
          },
        )
    );
  }
}
