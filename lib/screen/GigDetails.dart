import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../utils/colors.dart';
import 'MessageList.dart';

class GigDetails extends StatefulWidget {
  const GigDetails({super.key, required this.gigId, required this.isGig});
  final String gigId;
  final bool isGig;

  @override
  State<GigDetails> createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGreen,
      appBar: AppBar(
        backgroundColor: backGreen,
        title: Text('বিস্তারিত'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(widget.isGig ? 'gigs' : 'buyer_request').doc(widget.gigId).snapshots(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider.builder(
                    itemCount: 3,
                    options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                      aspectRatio: 1.5,
                      initialPage: 1,
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return FutureBuilder(
                          future: FirebaseStorage.instance.ref().child('${widget.isGig ? 'gigs' : 'buyer_request'}/${widget.gigId}/${index+1}.jpg').getDownloadURL(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              return _buildMockupImage(snapshot.data.toString());
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Profile Section
                        Row(
                          children: <Widget>[
                            FutureBuilder(
                              future: FirebaseStorage.instance.ref().child('${widget.isGig ? 'freelance_seller' : 'freelance_buyer'}/${snapshot.data['user']}/profile.jpg').getDownloadURL(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  return CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data.toString()), // Replace with your image
                                    radius: 26,
                                  );
                                }
                                return CircleAvatar(
                                  backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image
                                  radius: 26,
                                );
                              }
                            ),
                            SizedBox(width: 10),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection(widget.isGig ? 'freelance_seller' : 'freelancer_buyer').doc(snapshot.data['user']).snapshots(),
                              builder: (context,AsyncSnapshot snapshot) {
                                if(snapshot.hasData){
                                  print(snapshot.data.data());
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(snapshot.data['name'] ?? 'User',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                      Text(widget.isGig ? snapshot.data['skill'] ?? '' : snapshot.data['company_name'] ?? '',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('User',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )),
                                    Text('Skill',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Service Description
                        Text(
                          snapshot.data['title'],
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          color: primaryColor,
                          thickness: 1,
                        ),
                        Text(
                          snapshot.data['description'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('সার্ভিসগুলো:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontSize: 18
                                      ),
                                    ),
                                    Text(
                                      snapshot.data['service'],
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text('ডেলিভারি:',),
                                          Expanded(
                                            child: Divider(
                                              color: primaryColor,
                                              thickness: 1,
                                              indent: 5,
                                              endIndent: 5,
                                            ),
                                          ),
                                          Text(snapshot.data['delivery']),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text('রিভিশন:',),
                                          Expanded(
                                            child: Divider(
                                              color: primaryColor,
                                              thickness: 1,
                                              indent: 5,
                                              endIndent: 5,
                                            ),
                                          ),
                                          Text(snapshot.data['revision']),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text('প্রাইসিং:',),
                                          Expanded(
                                            child: Divider(
                                              color: primaryColor,
                                              thickness: 1,
                                              indent: 5,
                                              endIndent: 5,
                                            ),
                                          ),
                                          Text(snapshot.data['price'] + ' ৳'),
                                        ],
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        // Message Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    TextEditingController _controller = TextEditingController();

                                    return AlertDialog(
                                      title: Text('Message to this User'),
                                      content: TextField(
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          hintText: 'Write a message...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        maxLines: 3,
                                        minLines: 2,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            await FirebaseFirestore.instance.collection('chat').add({
                                              'time': Timestamp.now(),
                                              'user': [
                                                Hive.box('user').get('phone'),
                                                snapshot.data['user'],
                                              ],
                                              'sms' : [
                                                {
                                                  'text': _controller.text,
                                                  'user': Hive.box('user').get('phone'),
                                                  'time': Timestamp.now(),
                                                }
                                              ]
                                            }).then((value) {
                                              Navigator.pop(context);
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => MessageList()));
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent')));
                                            });
                                          },
                                          child: const Text('Send'),
                                        ),
                                      ],
                                    );
                                  }
                              );
                            },
                            label: Text(
                              'এখনি মেসেজ করুন',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            icon: Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      ),
    );
  }

  Widget _buildMockupImage(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
