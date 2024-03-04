import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumFiles extends StatefulWidget {
  const PremiumFiles({super.key});

  @override
  State<PremiumFiles> createState() => _PremiumFilesState();
}

class _PremiumFilesState extends State<PremiumFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Files'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admin').doc('premium_live').collection('files').snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        snapshot.data.docs[index]['title'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () async{
                        await launchUrl(Uri.parse(snapshot.data.docs[index]['url']));
                      },
                      subtitle: Text(
                        DateFormat('dd-MM-yyyy -- hh:mm:a').format(snapshot.data.docs[index]['time'].toDate()),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.download_for_offline_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}
