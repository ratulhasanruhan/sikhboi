import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
              'বিশেষ বার্তা',
              style: TextStyle(
                color: Colors.white,
              ),
          ),
        ),
      ),
      body: FirestoreListView(
          query: FirebaseFirestore.instance.collection('notice').orderBy('date', descending: true),
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(12),
          itemBuilder: (BuildContext context, DocumentSnapshot documentSnapshot) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Date: ${DateFormat('dd/MM/yyyy').format(documentSnapshot['date'].toDate())}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            documentSnapshot['headline'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(
                            color: Colors.grey[400],
                            thickness: .8,
                            height: 8,
                          ),
                          Text(
                            documentSnapshot['details'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .75,
                                child: Text(
                                  "লিংক: ${documentSnapshot['link']}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async{
                                    await launchUrl(Uri.parse(documentSnapshot['link']));
                                  },
                                  icon: Icon(
                                      Icons.arrow_forward,
                                    color: Colors.red,
                                  ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    documentSnapshot['image'] == null
                        ? SizedBox()
                        :
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        documentSnapshot['image'],
                        fit: BoxFit.cover,
                        height: 190,
                        width: MediaQuery.of(context).size.width,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}
