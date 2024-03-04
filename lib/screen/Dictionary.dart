import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'DictionaryDetails.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({Key? key}) : super(key: key);

  @override
  State<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends State<Dictionary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'শব্দার্থ শিখুন',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      body: FirestoreListView(
        padding: EdgeInsets.all(8),
        query: FirebaseFirestore.instance.collection('dictionary'),
        itemBuilder: (BuildContext context,  snapshot) {
          return Card(
            color: Colors.white,
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DictionaryDetails(name: snapshot['name'], id: snapshot.id,)));
              },
              title: Text(
                  snapshot['name'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              subtitle: Text(snapshot['title']),
              trailing: Image.network(snapshot['icon']),
            ),
          );
        },
      )
    );
  }
}
