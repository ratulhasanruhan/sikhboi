import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sikhboi/screen/Home.dart';
import 'package:sikhboi/utils/time_difference.dart';
import '../utils/colors.dart';
import 'AddFreelanceEntry.dart';

class FreelanceEntry extends StatefulWidget {
  final String id;
  final QueryDocumentSnapshot<Map<String, dynamic>> data;
  FreelanceEntry({super.key, required this.id, required this.data});

  @override
  State<FreelanceEntry> createState() => _FreelanceEntryState();
}

class _FreelanceEntryState extends State<FreelanceEntry> {
  var user = Hive.box('user').get('phone');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('জমাকৃত কাজগুলো'),

            user == widget.data['user']
                ? const Text('আপনার করা পোস্ট, আপনি রেটিং দিতে পারেন', style: TextStyle(fontSize: 12),)
                : Container()
          ],
        ),
        actions: [
          user == widget.data['user']
          ? Container()
          : IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFreelanceEntry(id: widget.id,)));
              }, 
              icon: Icon(Icons.add_circle_outline)
          )
        ],
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 6),
        height: 60,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFreelanceEntry(id: widget.id,)));
          },
          child: const Text('আপনার কাজ জমা দিন'),
        ),
      ),
      body: ListView(
        primary: true,
        padding: const EdgeInsets.all(8.0),
        children: [

          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('freelance').doc(widget.id).collection('entries').where('winner', isEqualTo: true).snapshots(),
              builder: (context, snap){
                if(snap.hasData){
                  if(snap.data!.docs.isNotEmpty){
                    return Column(
                      children: [
                        Stack(
                          children: [
                            Card(
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: (){

                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    snap.data?.docs[0].data()['image'] != ''
                                        ? ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: Image.network(
                                        snap.data?.docs[0].data()['image'],
                                        height: 200,
                                        width: double.infinity,
                                      ),
                                    )
                                        : Container(),
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'বিজয়ী 🏆',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('তারিখ: ${DateFormat('dd MMMM yyyy').format(snap.data?.docs[0].data()['time'].toDate())}',
                                            style: const TextStyle(fontSize: 16),),
                                          Divider(),
                                          StreamBuilder(
                                              stream: FirebaseFirestore.instance.collection('users').doc(snap.data?.docs[0].data()['user']).snapshots(),
                                              builder: (context, AsyncSnapshot snapshot){
                                                if(snapshot.hasData){

                                                  bool reviewed = snapshot.data.data().containsKey('review');

                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20,
                                                            child: Text(snapshot.data['name'][0].toString().toUpperCase(),
                                                              style: GoogleFonts.poppins(
                                                                fontWeight: FontWeight.w600,

                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 10,),
                                                          Text(snapshot.data['name'], style: const TextStyle(fontSize: 16),),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text('⭐ ${reviewed ? snapshot.data['review'] : '0'} টি রিভিউ',),
                                                          Text('আর্নিং: ${snapshot.data['point']} ৳'),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }
                                                return const SizedBox();
                                              }
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Lottie.asset(
                                'assets/confetti.json',
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                      ],
                    );
                  }
                }
                return Container();
              }
          ),

          FirestoreListView(
            shrinkWrap: true,
            primary: false,
            query: FirebaseFirestore.instance.collection('freelance').doc(widget.id).collection('entries').orderBy('time', descending: true),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, snapshot) {
              return Card(
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: (){

                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      snapshot['image'] != ''
                          ? ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            child: Image.network(
                                snapshot['image'],
                                height: 200,
                                width: double.infinity,
                              ),
                          )
                          : Container(),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(snapshot['description'], style: const TextStyle(fontSize: 16),),
                           const SizedBox(height: 5,),
                           user == widget.data['user']
                               ? RatingBar(
                             initialRating: snapshot['rating'].toDouble(),
                             direction: Axis.horizontal,
                             allowHalfRating: false,
                             itemCount: 5,
                             ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star, color: primaryColor,),
                                  half: const Icon(Icons.star_half, color: primaryColor,),
                                  empty: const Icon(Icons.star_border, color: primaryColor,)
                             ),
                             onRatingUpdate: (rating) async{
                               if(rating == 5){
                                 showDialog(
                                     context: context,
                                     builder: (context){
                                       TextEditingController email = TextEditingController();

                                       return AlertDialog(
                                         title: const Text('আপনি কি নিশ্চিত?'),
                                         content: Column(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             const Text(
                                                 '৫ ষ্টার দিলে আপনার এই কাজটি নির্বাচন করা হবে। পোস্ট টি সরিয়ে ফেলা হবে। এবং ফ্রীলান্সার কে পেমেন্ট দিয়ে দেয়া হবে। \n\nমূল ফাইল পাওয়ার জন্য আপনার ইমেইল দিন',
                                               textAlign: TextAlign.center,
                                             ),
                                             SizedBox(
                                               height: 10,
                                             ),
                                             TextField(
                                                controller: email,
                                                decoration: const InputDecoration(
                                                  label: Text('ইমেইল'),
                                                  border: OutlineInputBorder(),
                                              )
                                             )
                                           ],
                                         ),
                                         actions: [
                                           TextButton(
                                               onPressed: (){
                                                 Navigator.pop(context);
                                               },
                                               child: const Text('না')
                                           ),
                                           TextButton(
                                               onPressed: () async{

                                                 //TODO: Send email to freelancer
                                                 await FirebaseFirestore.instance.collection('notification').add({
                                                   'title': 'আপনি এই প্রতিযোগীতায় বিজয়ী হয়েছেন ✅',
                                                   'description': 'কাজের নাম: ${widget.data['title']}\nফাইল প্রদানের মেইল: ${email.text}\nক্লায়েন্ট ফোন: ${widget.data['user']}\nবাজেট: ${widget.data['price']} (শীঘ্রই ক্লাইন্টকে সোর্স ফাইল প্রদান করুন, দ্রুত পেমেন্ট দেওয়া হবে)',
                                                   'time': Timestamp.now(),
                                                   'user' : snapshot['user'],
                                                 });

                                                 await FirebaseFirestore.instance.collection('users').doc(snapshot['user']).update({
                                                   'review': FieldValue.increment(1),
                                                 });

                                                 await FirebaseFirestore.instance.collection('notification').add({
                                                   'title': 'আপনি কাজটি কন্ফার্ম করেছেন। শীঘ্রই আপনার প্রদানকৃত মেইলে ফাইল প্রদান করা হবে। ধন্যবাদ',
                                                   'description': 'ফ্রীলান্সার এর ফোন: ${snapshot['user']}',
                                                   'time': Timestamp.now(),
                                                   'user': user,
                                                 });

                                                 await FirebaseFirestore.instance.collection('succeed_work').add({
                                                   'buyer': user,
                                                   'freelancer': snapshot['user'],
                                                   'time' : Timestamp.now(),
                                                   'paid' : false,
                                                   'amount' : widget.data['price'],
                                                   'post_id' : widget.data.id,
                                                 });

                                                 await FirebaseFirestore.instance.collection('freelance').doc(widget.id).collection('entries').doc(snapshot.id).update({
                                                   'rating': rating.toInt(),
                                                   'winner': true,
                                                 }).then((value) {
                                                   Navigator.pop(context);

                                                   showDialog(
                                                       context: context,
                                                       builder: (context){
                                                         return AlertDialog(
                                                           backgroundColor: Colors.white,
                                                           title: Lottie.asset('assets/success.json', height: 150, width: 150),
                                                           content: Column(
                                                             mainAxisSize: MainAxisSize.min,
                                                             children: [
                                                               Text(
                                                                 'আপনার কাজটি সফফভাবে সম্পন্ন হয়েছে।',
                                                                 textAlign: TextAlign.center,
                                                               ),
                                                               SizedBox(height: 8),
                                                               MaterialButton(
                                                                 onPressed: (){
                                                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                                                                 },
                                                                 child: Text(
                                                                   'ওকে',
                                                                   style: TextStyle(
                                                                     color: Colors.white,
                                                                     fontWeight: FontWeight.bold,
                                                                   ),
                                                                 ),
                                                                 color: pinkish,
                                                                 shape: RoundedRectangleBorder(
                                                                   borderRadius: BorderRadius.circular(12),
                                                                 ),
                                                               )
                                                             ],
                                                           ),
                                                         );
                                                       }
                                                   );
                                                 });
                                               },
                                               child: const Text('হ্যাঁ')
                                           ),
                                         ],
                                       );
                                     }
                                 );
                               }else{
                                 await FirebaseFirestore.instance.collection('freelance').doc(widget.id).collection('entries').doc(snapshot.id).update({
                                   'rating': rating.toInt(),
                                 }).then((value) {
                                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('আপনার রেটিং সম্পন্ন হয়েছে')));
                                 });
                               }
                             },
                           )
                               :

                           RatingBarIndicator(
                             rating: snapshot['rating'].toDouble(),
                             itemBuilder: (context, index) => Icon(
                               Icons.star,
                               color: primaryColor,
                             ),
                             itemCount: 5,
                             itemSize: 30,
                             direction: Axis.horizontal,
                           ),
                           const SizedBox(height: 5,),
                           Text('জমার সময়: ${calculateTimeDifference(startDate: snapshot['time'].toDate(), endDate: DateTime.now())} আগে'.replaceAll('-', ''),
                             style: const TextStyle(fontSize: 16),),
                           Divider(

                           ),
                           StreamBuilder(
                             stream: FirebaseFirestore.instance.collection('users').doc(snapshot['user']).snapshots(),
                               builder: (context, AsyncSnapshot snapshot){
                                  if(snapshot.hasData){

                                    bool reviewed = snapshot.data.data().containsKey('review');

                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              child: Text(snapshot.data['name'][0].toString().toUpperCase(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,

                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text(snapshot.data['name'], style: const TextStyle(fontSize: 16),),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('⭐ ${reviewed ? snapshot.data['review'] : '0'} টি রিভিউ',),
                                            Text('আর্নিং: ${snapshot.data['point']} ৳'),
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                               }
                           )
                         ],
                       ),
                     ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
