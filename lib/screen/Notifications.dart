import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:hive/hive.dart';
import 'package:sikhboi/screen/WriteReview.dart';
import 'package:sikhboi/utils/colors.dart';
import 'package:sikhboi/utils/time_difference.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
        ),
        body: FirestoreListView(
          padding: const EdgeInsets.all(8.0),
          query: FirebaseFirestore.instance.collection('notification').where('user', isEqualTo: Hive.box('user').get('phone')).orderBy('time', descending: true),
          itemBuilder: (BuildContext context, DocumentSnapshot documentSnapshot) {
            return Card(
              child: ListTile(
                title: documentSnapshot['title'].toString().startsWith('Order')
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(documentSnapshot['title']),
                    TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WriteReview(product: documentSnapshot['description'])));
                        },
                        child: Text(
                          'রিভিউ দিন ⭐',
                          style: TextStyle(
                            color: pinkish,
                            fontWeight: FontWeight.w600
                          ),
                        )
                    )
                  ],
                )
                    : Text(documentSnapshot['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Text(documentSnapshot['description']),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            calculateTimeDifference(startDate: documentSnapshot['time'].toDate(), endDate: DateTime.now()).replaceAll('-', '') + ' আগে',
                          style: const TextStyle(color: Colors.grey, fontSize: 12)
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: (){
                                  Clipboard.setData(ClipboardData(text: documentSnapshot['description'])).then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('কপি করা হয়েছে')));
                                  });
                                },
                                icon: Icon(Icons.copy)
                            ),
                            IconButton(
                                onPressed: ()async{
                                  await FirebaseFirestore.instance.collection('notification').doc(documentSnapshot.id).delete().then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('মুছে ফেলা হয়েছে')));
                                  });
                                },
                                icon: Icon(Icons.delete)
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }
}
